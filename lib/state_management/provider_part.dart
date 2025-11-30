import 'package:flutter/material.dart';

class ProviderPart extends ChangeNotifier {
  Map<String, dynamic>? _val;

  Map<String, dynamic>? get val => _val;

  void displayVal(Map<String, dynamic>? newValue) {
    _val = newValue;
    notifyListeners();
  }
}
