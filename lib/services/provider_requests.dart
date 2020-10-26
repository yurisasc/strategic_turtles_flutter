import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/utils/constants.dart';

/// Request service that handles any operations
/// related to creating, accepting and rejecting requests.
class RequestsProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get all the request sent by the user id
  Stream<List<RequestModel>> getSentRequests(String firebaseUid) {
    return _db
        .collection('/requests/')
        .where('senderId', isEqualTo: firebaseUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => RequestModel.fromSnapshot(e)).toList());
  }

  /// Get all the request received by the user id
  Stream<List<RequestModel>> getReceivedRequests(String firebaseUid) {
    return _db
        .collection('/requests/')
        .where('receiverId', isEqualTo: firebaseUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => RequestModel.fromSnapshot(e)).toList());
  }

  /// Create a request
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

  /// Accept a request and update the request status to "Accepted".
  /// If it is successful, then assign the broker into the paddock.
  Future<bool> acceptRequest(
    String requestId,
    String brokerId,
    String paddockId,
  ) async {
    // Try to accept the request
    try {
      await _db
          .collection('/requests/')
          .doc(requestId)
          .update({'status': Constants.Accepted});
    } catch (_) {
      return false;
    }

    // Assign the broker into the paddock
    await _db
        .collection('/paddocks/')
        .doc(paddockId)
        .update({'brokerId': brokerId});

    return true;
  }

  /// Decline the request and updates the status to "Rejected"
  Future<bool> declineRequest(String requestId) async {
    try {
      await _db
          .collection('/requests/')
          .doc(requestId)
          .update({'status': Constants.Rejected});
      return true;
    } catch (_) {
      return false;
    }
  }
}
