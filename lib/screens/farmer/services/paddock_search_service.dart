import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:strategic_turtles/models/models.dart';

/// Service to handle paddock searching for farmer
class PaddockSearchService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ValueNotifier<List<PaddockModel>> paddocks = ValueNotifier([]);
  List<PaddockModel> temp = [];

  /// Search paddock that is not yet reserved by any broker
  Future<void> searchPaddock(String uid, String query) async {
    if (query.length <= 1) {
      paddocks.value = await _db
          .collection('/paddocks/')
          .where('ownerId', isEqualTo: uid)
          .where('brokerId', isNull: true)
          .get()
          .then((value) =>
              value.docs.map((e) => PaddockModel.fromSnapshot(e)).toList());
      temp = paddocks.value;
    } else {
      paddocks.value =
          temp.where((element) => element.name.startsWith(query)).toList();
    }
  }
}
