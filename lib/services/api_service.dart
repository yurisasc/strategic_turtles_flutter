import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:strategic_turtles/models/prediction_response.dart';

class ApiServiceIdentifier {
  static const BASE_URL = "https://deco3801-strategic-turtles.uqcloud.net";
  static const PREDICT = "/Simulation/Run";
  static const PARAM_START = "?";
  static const PARAM_VALUE = "=";
  static const PARAM_SEPARATOR = "&";
}

class ApiService {

  /// Call the prediction API to get farm yield prediction
  Future<PredictionResponse> predict(Map<String, dynamic> params) async {
    var client = http.Client();

    String url = ApiServiceIdentifier.BASE_URL + ApiServiceIdentifier.PREDICT;
    url += ApiServiceIdentifier.PARAM_START;
    params.entries.forEach((entry) {
      url += entry.key +
          ApiServiceIdentifier.PARAM_VALUE +
          entry.value.toString() +
          ApiServiceIdentifier.PARAM_SEPARATOR;
    });
    print(url);

    try {
      var response = await client.get(url).timeout(const Duration(seconds: 60));
      return PredictionResponse.fromString(response.body);
    } on Exception catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
