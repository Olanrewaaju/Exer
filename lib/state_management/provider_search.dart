import 'package:flutter/material.dart';
import 'package:exer/database/initial_database.dart';

class ProviderSearch extends ChangeNotifier {
  String _searchedWord = '';
  bool _hydrated = false;
  bool _loading = false;

  String get searchedWord => _searchedWord;
  bool get hydrated => _hydrated;
  bool get loading => _loading;

  Future<void> loadLastQueryFromDb() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();

    try {
      final results = await InitialDatabase.instance.displaySearch();
      if (results.isNotEmpty) {
        final last = (results.first['searchedWord'] ?? '').toString().trim();
        if (last.isNotEmpty) {
          _searchedWord = last;
        }
      }
    } finally {
      _hydrated = true;
      _loading = false;
      notifyListeners();
    }
  }

  void searches(String word) {
    final normalized = word.trim();
    if (normalized == _searchedWord) return;
    _searchedWord = normalized;
    notifyListeners();
  }

  Future<void> setAndPersist(String word) async {
    final normalized = word.trim();
    if (normalized.isEmpty) return;

    searches(normalized);
    await InitialDatabase.instance.insertSearch({'searchedWord': normalized});
  }
}
