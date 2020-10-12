import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';

class AuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Firebase user one-time fetch
  auth.User get getUser => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<auth.User> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Future<UserModel> firestoreUser(auth.User firebaseUser) {
    if (firebaseUser?.uid != null) {
      return _db
          .doc('/users/${firebaseUser.uid}')
          .snapshots()
          .map((snapshot) => UserModel.fromMap(snapshot.data()))
          .first;
    }
    return null;
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // User registration using email and password
  Future<bool> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String role,
    String farmName,
    String password,
  ) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        print('uID: ' + result.user.uid);
        print('email: ' + result.user.email);
        //create the new user object
        UserModel _newUser = UserModel(
            uid: result.user.uid,
            email: result.user.email,
            firstName: firstName,
            lastName: lastName,
            role: role,
            farmName: farmName,
            photoUrl: null);
        //update the user in firestore
        _updateUserFirestore(_newUser, result.user);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //updates the firestore users collection
  void _updateUserFirestore(UserModel user, auth.User firebaseUser) {
    _db
        .doc('/users/${firebaseUser.uid}')
        .set(user.toJson(), SetOptions(merge: true));
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
