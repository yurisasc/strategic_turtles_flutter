import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:strategic_turtles/models/prediction_response.dart';

class ApiServiceIdentifier {
  static const BASE_URL = "https://deco3801-strategic-turtles.uqcloud.net";
  static const PREDICT = "/Simulation/Run";
}

class ApiService {
  Future<double> predict(Map<String, dynamic> params) async {
    var client = http.Client();
    String url = ApiServiceIdentifier.BASE_URL + ApiServiceIdentifier.PREDICT;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Negotiate'
      };
      var response = await client
          .post(url, body: params.toString(), headers: requestHeaders)
          .timeout(const Duration(seconds: 15));
      final responseMap = json.decode(response.body);
      return PredictionResponse.fromMap(responseMap).result;
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
