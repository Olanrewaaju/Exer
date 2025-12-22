import 'package:flutter/material.dart';

import 'package:exer/database/initial_database.dart';

class RecentProvider extends ChangeNotifier {
  final List<String> _recentWords = [];

  List<String> get recentWords => _recentWords;

  Future<void> loadFromDb() async {
    final results = await InitialDatabase.instance.displaySearch();
    final words = results
        .map((row) => (row['searchedWord'] ?? '').toString())
        .where((w) => w.trim().isNotEmpty)
        .toList();
    hydrate(words);
  }

  void hydrate(List<String> words) {
    final seen = <String>{};

    _recentWords.clear();
    for (final word in words) {
      final normalized = word.trim();
      if (normalized.isEmpty) continue;
      if (!seen.add(normalized)) continue;
      _recentWords.add(normalized);
    }
    notifyListeners();
  }

  void addtoList(String word) {
    final normalized = word.trim();
    if (normalized.isEmpty) return;

    // Keep most-recent-first ordering.
    _recentWords.remove(normalized);
    _recentWords.insert(0, normalized);
    notifyListeners();
  }

  Future<void> addAndPersist(String word) async {
    final normalized = word.trim();
    if (normalized.isEmpty) return;

    addtoList(normalized);
    await InitialDatabase.instance.insertSearch({'searchedWord': normalized});
  }
}
