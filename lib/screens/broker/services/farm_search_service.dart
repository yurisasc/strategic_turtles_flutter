import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/utils/constants.dart';

class FarmSearchService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ValueNotifier<List<UserModel>> farmers = ValueNotifier([]);
  List<UserModel> temp = [];

  Future<void> searchFarm(String uid, String query) async {
    if (query.length <= 1) {
      final sentRequestId = await _db
          .collection('/requests/')
          .where('senderId', isEqualTo: uid)
          .get()
          .then((value) => value.docs
              .map((e) => RequestModel.fromMap(e.data()).receiverId)
              .toList());

      final result = await _db
          .collection('/users/')
          .where('role', isEqualTo: Constants.Farmer)
          .orderBy('farmName')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList());

      farmers.value = result
          .where((element) => !sentRequestId.contains(element.uid))
          .toList();
      temp = farmers.value;
    } else {
      farmers.value =
          temp.where((element) => element.farmName.startsWith(query)).toList();
    }
  }
}
