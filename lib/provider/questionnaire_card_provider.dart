import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walnut_home_page/constants/constants.dart';

class QuestionnaireCard extends ChangeNotifier {
  QuestionnaireCard({required this.title, bool isComplete = false})
    : _isComplete = isComplete;

  final String title;
  bool _isComplete;

  bool get isComplete => _isComplete;

  void markComplete(bool value) {
    if (_isComplete == value) return;
    _isComplete = value;
    notifyListeners();
  }
}

class QuestionnaireCardsProvider extends ChangeNotifier {
  final List<QuestionnaireCard> _cards = [];
  Future<void> fetchsections() async {
    final url = '$baseUrl/questionnaires/templates/$template/latest';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load sections');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final List sections = data['sections'] as List;

      for (final section in sections) {
        _cards.add(QuestionnaireCard(title: section['title']));
      }
    } catch (e) {
      log("this is the error log :"+ e.toString());
    }
  }

  List<QuestionnaireCard> get cards => List.unmodifiable(_cards);
}
