import 'package:flutter/foundation.dart';

class QuestionnaireCard extends ChangeNotifier {
  QuestionnaireCard({
    required this.title,
    bool isComplete = false,
  }) : _isComplete = isComplete;

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
  final List<QuestionnaireCard> _cards = [
    QuestionnaireCard(title: "Basic Profile"),
    QuestionnaireCard(title: "Lifestyle Routine"),
    QuestionnaireCard(title: "Personal Life Relationship Health"),
    QuestionnaireCard(title: "Previous Care Experiences"),
    QuestionnaireCard(title: "Primary Goals"),
    QuestionnaireCard(title: "Career Life Financial Aspirations"),
    QuestionnaireCard(title: "Longevity Biohacking Mindset"),
    QuestionnaireCard(title: "Your Commitment"),
  ];

  List<QuestionnaireCard> get cards => List.unmodifiable(_cards);
}