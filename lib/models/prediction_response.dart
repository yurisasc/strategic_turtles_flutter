class PredictionResponse {
  final double result;
  final String errorMessage;

  PredictionResponse({
    this.result,
    this.errorMessage,
  });

  factory PredictionResponse.fromString(String data) {
    try {
      final value = double.parse(data);
      return PredictionResponse(result: value);
    } on Exception catch (_) {
      return PredictionResponse(errorMessage: data);
    }
  }

  Map<String, dynamic> toJson() => {
    "result": result,
  };
}
