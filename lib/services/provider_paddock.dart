import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/models/prediction_response.dart';
import 'package:strategic_turtles/services/api_service.dart';
import 'package:strategic_turtles/utils/constants.dart';

/// Service to handle any operation related to
/// paddock creation, querying and editing
class PaddockProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  String errorMessage;

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
      {runPrediction = false}) async {
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
      if (runPrediction) {
        errorMessage = null;
        loading = true;
        notifyListeners();
        final prediction = await getPrediction(paddock);
        loading = false;
        notifyListeners();

        final predictionValue = _getPredictionValue(prediction);

        if (predictionValue != null) {
          paddock.estimatedYield = predictionValue;
        } else {
          errorMessage = prediction.errorMessage;
          notifyListeners();
          return false;
        }
      }
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
      errorMessage = null;
      loading = true;
      notifyListeners();
      final predictionResponse = await getPrediction(paddock);
      loading = false;
      notifyListeners();

      final predictionValue = _getPredictionValue(predictionResponse);

      if (predictionValue != null) {
        data['estimatedYield'] = predictionValue;
        paddock.estimatedYield = predictionValue;
      } else {
        errorMessage = predictionResponse.errorMessage;
        notifyListeners();
      }
    }

    try {
      await _db.collection('/paddocks/').doc(paddock.id).update(data);
      return paddock;
    } catch (_) {
      return null;
    }
  }

  /// Run a prediction for the paddock.
  Future<PredictionResponse> getPrediction(PaddockModel paddock) async {
    Map<String, dynamic> params = {
      "cropType": paddock.cropName,
      "paddockArea": paddock.sqmSize,
      "startDate": paddock.createdDate
          .subtract(Duration(days: 1))
          .toString()
          .split(" ")[0],
      "endDate": paddock.createdDate.toString().split(" ")[0],
      "longitude": paddock.longitude.toStringAsFixed(6),
      "latitude": paddock.latitude.toStringAsFixed(6),
    };

    return await ApiService().predict(params);
  }

  List<double> _getPredictionValue(PredictionResponse predictionResponse) {
    if (predictionResponse.result != null) {
      final paddedResult = [
        predictionResponse.result,
        2 * predictionResponse.result,
      ];
      return paddedResult;
    } else {
      return null;
    }
  }
}
