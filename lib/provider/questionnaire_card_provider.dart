import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walnut_home_page/constants/constants.dart';
class QuestionnaireCard extends ChangeNotifier {
  QuestionnaireCard({
    required this.title,
    bool isComplete = false,
  }) : _isComplete = isComplete;

  final String title;
  bool _isComplete;

  bool get isComplete => _isComplete;

  void markComplete() {
    if (_isComplete) return;
    _isComplete = true;
    notifyListeners();
  }

  void markIncomplete() {
    if (!_isComplete) return;
    _isComplete = false;
    notifyListeners();
  }
}
class QuestionnaireCardsProvider extends ChangeNotifier {
  final List<QuestionnaireCard> _cards = [];

  List<QuestionnaireCard> get cards => List.unmodifiable(_cards);

  int get total => _cards.length;

  int get completed =>
      _cards.where((c) => c.isComplete).length;

  double get progress =>
      total == 0 ? 0 : completed / total;

  /// 🔹 Fetch ONCE from backend
  Future<void> fetchSections() async {
    final url =
        '$baseUrl/questionnaires/templates/$template/latest?userId=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch sections');
      }

      final data = jsonDecode(response.body);
      final sections = data['sections'] as List;

      _cards.clear();

      for (final s in sections) {
        _cards.add(
          QuestionnaireCard(
            title: s['title'],
            isComplete:
                s['completed'].toString().trim() == 'true',
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      log('fetchSections error: $e');
    }
  }

  /// 🔹 LOCAL update (NO backend call)
  void completeSection(int index) {
    if (index < 0 || index >= _cards.length) return;

    _cards[index].markComplete();

    // progress updates automatically
    notifyListeners();
  }
}

// http://localhost:8080/api/v1/questionnaires/templates/health_intake/versions/1/sections/basic_profile
