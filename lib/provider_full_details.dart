import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderFullDetails extends ChangeNotifier {
  String _word = '';

  String get word => _word;

  void displayVal(String newWord) {
    _word = newWord;
    notifyListeners();
  }
}
