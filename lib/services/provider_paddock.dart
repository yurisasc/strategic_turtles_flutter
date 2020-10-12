import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/utils/constants.dart';

class PaddockProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PaddockModel>> getPaddocks(String firebaseUid, String role) {
    if (role == Constants.Farmer) {
      return _db
          .collection('/paddocks/')
          .where('ownerId', isEqualTo: firebaseUid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => PaddockModel.fromMap(e.data()))
              .toList());
    } else {
      return _db
          .collection('/paddocks/')
          .where('brokerId', isEqualTo: firebaseUid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => PaddockModel.fromMap(e.data()))
              .toList());
    }
  }

  Stream<List<PaddockModel>> getAllPaddocks() {
    return _db.collection('/paddocks/').snapshots().map((snapshot) =>
        snapshot.docs.map((e) => PaddockModel.fromMap(e.data())).toList());
  }

  Future<bool> createPaddock(
    String ownerId,
    String name,
    double latitude,
    double longitude,
    double sqmSize,
    String cropName,
    DateTime harvestDate,
    int numSeed,
  ) async {
    String id = _db.collection('/paddocks/').doc().id;
    final paddock = PaddockModel(
      id: id,
      ownerId: ownerId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      sqmSize: sqmSize,
      cropName: cropName,
      harvestDate: harvestDate,
      numSeed: numSeed,
    );
    try {
      await _db.collection('/paddocks/').add(paddock.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
