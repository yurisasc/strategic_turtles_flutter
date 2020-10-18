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
              .map((e) => PaddockModel.fromSnapshot(e))
              .toList());
    } else {
      return _db
          .collection('/paddocks/')
          .where('brokerId', isEqualTo: firebaseUid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => PaddockModel.fromSnapshot(e))
              .toList());
    }
  }

  Stream<List<PaddockModel>> getAllPaddocks() {
    return _db.collection('/paddocks/').snapshots().map((snapshot) =>
        snapshot.docs.map((e) => PaddockModel.fromSnapshot(e)).toList());
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
    final paddock = PaddockModel(
      ownerId: ownerId,
      brokerId: null,
      name: name,
      latitude: latitude,
      longitude: longitude,
      sqmSize: sqmSize,
      cropName: cropName,
      harvestDate: harvestDate,
      numSeed: numSeed,
      estimatedYield: null,
      potentialProfit: null,
    );
    try {
      await _db.collection('/paddocks/').add(paddock.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
