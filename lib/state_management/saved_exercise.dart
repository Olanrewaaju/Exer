import 'package:flutter/material.dart';

class SavedExercise extends ChangeNotifier {
  final List<Map<String, dynamic>> _bookmarkedItem = [];

  List<Map<String, dynamic>> get bookmarkedItem => _bookmarkedItem;

  bool isBookmarked(String? id) {
    final normalized = (id ?? '').trim();
    if (normalized.isEmpty) return false;
    return _bookmarkedItem.any(
      (item) => (item['exerciseId'] ?? '').toString() == normalized,
    );
  }

  void addBookmark(Map<String, dynamic> item) {
    final id = (item['exerciseId'] ?? '').toString().trim();
    if (id.isEmpty) return;
    if (!isBookmarked(id)) {
      _bookmarkedItem.add(item);
      notifyListeners();
    }
    notifyListeners();
  }

  void removeBookmark(String? id) {
    final normalized = (id ?? '').trim();
    if (normalized.isEmpty) return;
    _bookmarkedItem.removeWhere(
      (item) => (item['exerciseId'] ?? '').toString() == normalized,
    );
    notifyListeners();
  }

  void toggeBookmarks(Map<String, dynamic> item) {
    final id = (item['exerciseId'] ?? '').toString().trim();
    if (id.isEmpty) return;
    if (isBookmarked(id)) {
      removeBookmark(id);
    } else {
      addBookmark(item);
    }
    notifyListeners();
  }
}
