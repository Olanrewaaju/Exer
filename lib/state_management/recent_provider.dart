import 'package:flutter/material.dart';

class RecentProvider extends ChangeNotifier {
  List<String> _recentWords = [];

  List<String> get recentWords => _recentWords;

  void addtoList(String word) {
    if (word.trim().isEmpty) return;

    if (!_recentWords.contains(word)) {
      _recentWords.add(word);
      notifyListeners();
    }
  }
}
