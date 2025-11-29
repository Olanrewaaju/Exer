import 'package:flutter/material.dart';

class ProviderPart extends ChangeNotifier {
  final int _val = 0;

  int get val => _val;

  void displayVal(int newValue) {
    newValue = _val;
    notifyListeners();
  }
}
