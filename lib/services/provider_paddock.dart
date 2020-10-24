import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/utils/constants.dart';

class PaddockProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, List<PaddockModel>>> getPaddocks(
      String firebaseUid, String role) async {
    List<PaddockModel> paddocks;
    if (role == Constants.Farmer) {
      paddocks = await _db
          .collection('/paddocks/')
          .where('ownerId', isEqualTo: firebaseUid)
          .get()
          .then((value) =>
              value.docs.map((e) => PaddockModel.fromSnapshot(e)).toList());
    } else {
      paddocks = await _db
          .collection('/paddocks/')
          .where('brokerId', isEqualTo: firebaseUid)
          .get()
          .then((value) =>
              value.docs.map((e) => PaddockModel.fromSnapshot(e)).toList());
    }

    Map<String, List<PaddockModel>> result = {};
    for (PaddockModel paddock in paddocks) {
      if (result.containsKey(paddock.ownerId)) {
        result[paddock.ownerId] = [...result[paddock.ownerId], paddock];
      } else {
        result.putIfAbsent(paddock.ownerId, () => [paddock]);
      }
    }

    return result;
  }

  Stream<List<PaddockModel>> getAllPaddocks() {
    return _db.collection('/paddocks/').snapshots().map((snapshot) =>
        snapshot.docs.map((e) => PaddockModel.fromSnapshot(e)).toList());
  }

  Future<bool> createPaddock(
    String ownerId,
    String name,
    String farmName,
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
      farmName: farmName,
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
      final prediction = await getPrediction(paddock, true);
      paddock.estimatedYield = prediction;
      await _db.collection('/paddocks/').add(paddock.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<PaddockModel> editPaddock(
    PaddockModel paddock,
    bool rePredict,
  ) async {
    final data = {
      'name': paddock.name,
      'cropName': paddock.cropName,
      'sqmSize': paddock.sqmSize,
    };

    // Re-run the prediction if sqmSize changed;
    if (rePredict) {
      final result = await getPrediction(paddock, false);
      data['estimatedYield'] = result;
      paddock.estimatedYield = result;
    }

    try {
      await _db.collection('/paddocks/').doc(paddock.id).update(data);
      return paddock;
    } catch (_) {
      return null;
    }
  }

  Future<List<double>> getPrediction(PaddockModel paddock, bool isNewPaddock) {
    Map<String, dynamic> params = {
      "cropType": paddock.cropName,
      "sqmSize": paddock.sqmSize,
      "longitude": paddock.longitude,
      "latitude": paddock.latitude,
    };

    if (isNewPaddock) {
      params["startDate"] = DateTime.now();
      params["endDate"] = DateTime.now().add(Duration(days: 366));
    }

    // Will be replaced by a real value once the API is ready
    final random = Random();
    double randomDouble = random.nextDouble();

    final paddedResult = [
      randomDouble,
      2 * (randomDouble),
    ];

    return Future<List<double>>.value(paddedResult);
  }
}
