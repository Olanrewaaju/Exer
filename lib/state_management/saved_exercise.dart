import 'package:flutter/material.dart';

class SavedExercise extends ChangeNotifier {
  final List<Map<String, dynamic>> _bookmarkedItem = [];

  List<Map<String, dynamic>> get bookmarkedItem => _bookmarkedItem;

  bool isBookmarked(String id) {
    return _bookmarkedItem.any((item) => item['exerciseId'] == id);
  }

  void addBookmark(Map<String, dynamic> item) {
    if (!isBookmarked(item['exerciseId'])) {
      _bookmarkedItem.add(item);
      notifyListeners();
    }
  }

  void removeBookmark(String id) {
    _bookmarkedItem.removeWhere((item) => item['exerciseId'] == id);
    notifyListeners();
  }

  void toggeBookmarks(Map<String, dynamic> item) {
    if (isBookmarked(item['exerciseId'])) {
      removeBookmark(item['exerciseId']);
    } else {
      addBookmark(item);
    }
  }
}
