class RequestModel {
  String senderId;
  String senderName;
  String receiverId;
  String receiverFarmName;
  String status;

  RequestModel({
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverFarmName,
    this.status,
  });

  factory RequestModel.fromMap(Map data) {
    return RequestModel(
      senderId: data['senderId'],
      senderName: data['senderName'],
      receiverId: data['receiverId'],
      receiverFarmName: data['receiverFarmName'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "senderName": senderName,
    "receiverId": receiverId,
    "receiverFarmName": receiverFarmName,
    "status": status,
  };
}
