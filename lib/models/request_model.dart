import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  String id;
  String senderId;
  String senderName;
  String receiverId;
  String receiverFarmName;
  String status;

  RequestModel({
    this.id,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverFarmName,
    this.status,
  });

  factory RequestModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final id = snapshot.id;
    final data = snapshot.data();

    return RequestModel(
      id: id,
      senderId: data['senderId'],
      senderName: data['senderName'],
      receiverId: data['receiverId'],
      receiverFarmName: data['receiverFarmName'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "senderName": senderName,
    "receiverId": receiverId,
    "receiverFarmName": receiverFarmName,
    "status": status,
  };
}
