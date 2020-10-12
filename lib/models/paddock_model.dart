class PaddockModel {
  String id;
  String ownerId;
  String brokerId;
  String name;
  double latitude;
  double longitude;
  double sqmSize;
  String cropName;
  DateTime harvestDate;
  int numSeed;
  double estimatedYield;
  double potentialProfit;

  PaddockModel({
    this.id,
    this.ownerId,
    this.brokerId,
    this.name,
    this.latitude,
    this.longitude,
    this.sqmSize,
    this.cropName,
    this.harvestDate,
    this.numSeed,
    this.estimatedYield,
    this.potentialProfit,
  });

  factory PaddockModel.fromMap(Map data) {
    return PaddockModel(
      id: data['id'],
      ownerId: data['ownerId'],
      brokerId: data['brokerId'],
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      sqmSize: data['sqmSize'],
      cropName: data['cropName'],
      harvestDate: DateTime.parse(data['harvestDate']).toLocal(),
      numSeed: data['numSeed'],
      estimatedYield: data['estimatedYield'],
      potentialProfit: data['potentialProfit'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "ownerId": ownerId,
        "brokerId": brokerId,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "sqmSize": sqmSize,
        "cropName": cropName,
        "harvestDate": harvestDate.toUtc().toString(),
        "numSeed": numSeed,
        "estimatedYield": estimatedYield,
        "potentialProfit": potentialProfit,
      };
}
