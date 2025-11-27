import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderPart extends ChangeNotifier {
  String _word = '';

  String get words => _word;

  void displayVal(String newWPart) {
    _word = newWPart;
    notifyListeners();
  }
}
