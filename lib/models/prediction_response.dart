class PredictionResponse {
  final double result;

  PredictionResponse({
    this.result,
  });

  factory PredictionResponse.fromMap(Map data) {
    return PredictionResponse(result: double.parse(data['result']));
  }

  Map<String, dynamic> toJson() => {
    "result": result,
  };
}
