import 'package:cloud_firestore/cloud_firestore.dart';

class PaddockModel {
  String id;
  String ownerId;
  String brokerId;
  String name;
  String farmName;
  double latitude;
  double longitude;
  double sqmSize;
  String cropName;
  DateTime harvestDate;
  int numSeed;
  List<double> estimatedYield;
  double potentialProfit;

  PaddockModel({
    this.id,
    this.ownerId,
    this.brokerId,
    this.name,
    this.farmName,
    this.latitude,
    this.longitude,
    this.sqmSize,
    this.cropName,
    this.harvestDate,
    this.numSeed,
    this.estimatedYield,
    this.potentialProfit,
  });

  factory PaddockModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final id = snapshot.id;
    final data = snapshot.data();

    return PaddockModel(
      id: id,
      ownerId: data['ownerId'],
      brokerId: data['brokerId'],
      name: data['name'],
      farmName: data['farmName'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      sqmSize: data['sqmSize'],
      cropName: data['cropName'],
      harvestDate: DateTime.parse(data['harvestDate']).toLocal(),
      numSeed: data['numSeed'],
      estimatedYield: List.from(data['estimatedYield'] ?? []),
      potentialProfit: data['potentialProfit'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerId": ownerId,
        "brokerId": brokerId,
        "name": name,
        "farmName": farmName,
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
