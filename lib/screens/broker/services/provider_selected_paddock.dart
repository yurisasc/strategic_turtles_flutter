import 'package:flutter/cupertino.dart';
import 'package:strategic_turtles/models/models.dart';

class SelectedPaddock with ChangeNotifier {
  PaddockModel selectedPaddock;

  void selectPaddock(PaddockModel paddock) {
    selectedPaddock = paddock;
    notifyListeners();
  }
}