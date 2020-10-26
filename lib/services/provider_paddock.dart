import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/api_service_identifiers.dart';
import 'package:strategic_turtles/utils/constants.dart';

/// Service to handle any operation related to
/// paddock creation, querying and editing
class PaddockProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;

  /// Get the paddock related to the user.
  /// If the user is a farmer, then get the created paddocks.
  /// If the user is a broker, then get the accepted paddocks.
  Future<Map<String, List<PaddockModel>>> getPaddocks(
    String firebaseUid,
    String role,
  ) async {
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

  /// Create a paddock
  Future<bool> createPaddock(
    String ownerId,
    String name,
    String farmName,
    double latitude,
    double longitude,
    double sqmSize,
    String cropName,
    DateTime createdDate,
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
      createdDate: createdDate,
      harvestDate: harvestDate,
      numSeed: numSeed,
      estimatedYield: null,
      potentialProfit: null,
    );
    try {
      final prediction = await getPrediction(paddock);
      paddock.estimatedYield = prediction;
      await _db.collection('/paddocks/').add(paddock.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Edit the editable attributes of the paddock.
  /// param: paddock is the [PaddockModel] representing the edited paddock
  /// param: rePredict is to decide whether to rerun prediction or not.
  Future<PaddockModel> editPaddock(
    PaddockModel paddock,
    bool rePredict,
  ) async {
    final data = {
      'name': paddock.name,
      'cropName': paddock.cropName,
      'sqmSize': paddock.sqmSize,
    };

    // Re-run the prediction
    if (rePredict) {
      final result = await getPrediction(paddock);
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

  /// Run a prediction for the paddock.
  Future<List<double>> getPrediction(PaddockModel paddock) async {
    Map<String, dynamic> params = {
      "cropType": paddock.cropName,
      "paddockArea": paddock.sqmSize,
      "startDate": paddock.createdDate,
      "endDate": paddock.harvestDate,
      "longitude": paddock.longitude,
      "latitude": paddock.latitude,
    };

    loading = true;
    notifyListeners();

    double predictedYield = await ApiService().predict(params);

    final paddedResult = [
      predictedYield,
      2 * (predictedYield),
    ];

    loading = false;
    notifyListeners();

    return Future<List<double>>.value(paddedResult);
  }
}
