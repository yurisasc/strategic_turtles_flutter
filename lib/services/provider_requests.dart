import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/utils/constants.dart';

class RequestsProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<RequestModel>> getSentRequests(String firebaseUid) {
    return _db
        .collection('/requests/')
        .where('senderId', isEqualTo: firebaseUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => RequestModel.fromSnapshot(e)).toList());
  }

  Stream<List<RequestModel>> getReceivedRequests(String firebaseUid) {
    return _db
        .collection('/requests/')
        .where('receiverId', isEqualTo: firebaseUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => RequestModel.fromSnapshot(e)).toList());
  }

  Future<bool> createRequest(
    String senderId,
    String senderName,
    String receiverId,
    String receiverFarmName,
  ) async {
    String id = _db.collection('/requests/').doc().id;
    final request = RequestModel(
      id: id,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverFarmName: receiverFarmName,
      status: Constants.Pending,
    );
    try {
      await _db.collection('/requests/').add(request.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> acceptRequest(
    String requestId,
    String brokerId,
    String paddockId,
  ) async {
    try {
      await _db
          .collection('/requests/')
          .doc(requestId)
          .update({'status': Constants.Accepted});
    } catch (_) {
      return false;
    }

    await _db
        .collection('/paddocks/')
        .doc(paddockId)
        .update({'brokerId': brokerId});

    return true;
  }

  Future<bool> declineRequest() {}
}
