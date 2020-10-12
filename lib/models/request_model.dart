class RequestModel {
  String senderId;
  String senderName;
  String receiverId;
  String paddockName;
  String paddockId;
  String status;

  RequestModel({
    this.senderId,
    this.senderName,
    this.receiverId,
    this.paddockName,
    this.paddockId,
    this.status,
  });

  factory RequestModel.fromMap(Map data) {
    return RequestModel(
      senderId: data['senderId'],
      senderName: data['senderName'],
      receiverId: data['receiverId'],
      paddockName: data['paddockName'],
      paddockId: data['paddockId'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "senderName": senderName,
    "receiverId": receiverId,
    "paddockId": paddockId,
    "status": status,
  };
}
