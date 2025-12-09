import 'package:flutter/material.dart';

class ProviderSearch extends ChangeNotifier {
  String _searchedWord = '';

  String get searchedWord => _searchedWord;
  void searches(String word) {
    _searchedWord = word;
    notifyListeners();
  }
}
