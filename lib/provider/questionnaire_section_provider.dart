import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walnut_home_page/constants/constants.dart';
import 'package:walnut_home_page/models/questionnare_section.dart';

class _Answer {
  final dynamic value;
  final String questionType;

  _Answer(this.value, this.questionType);
}

class QuestionnaireSectionProvider extends ChangeNotifier {


  // final String baseUrl=baseUrl;
  // final String template;
  // final int version;
  // final String userId;

  QuestionnareSection? _section;
  bool _loading = false;

  final Map<String, _Answer> _answers = {};


  QuestionnareSection? get section => _section;
  bool get isLoading => _loading;

  int get totalQuestions => _section?.questions.length ?? 0;
  int get answeredCount => _answers.length;

  // dynamic answerFor(String questionKey) => _answers[questionKey];
Future<void> fetchSection(String sectionKey) async {
  _loading = true;
  notifyListeners();

  final url =
      '$baseUrl/questionnaires/templates/$template/versions/$version/sections/$sectionKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    _loading = false;
    notifyListeners();
    throw Exception('Failed to load questionnaire section');
  }

  _section = QuestionnareSection.fromJson(json.decode(response.body));

  // Optional: Clear answers for this section only
  // This prevents stale data if user navigates back
  _answers.removeWhere((key, value) => key.startsWith('$sectionKey.'));

  _loading = false;
  notifyListeners();
}

  // Update handlers to include question type
  void updateSingleChoice(String questionKey, String optionKey) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    _answers[fullQuestionKey] = _Answer(optionKey, 'single_correct');
    notifyListeners();
  }

  void updateMultiChoice(String questionKey, String optionKey, bool selected) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    final current =
        _answers[fullQuestionKey]?.value as Set<String>? ?? <String>{};

    final updated = Set<String>.from(current);
    selected ? updated.add(optionKey) : updated.remove(optionKey);

    if (updated.isEmpty) {
      _answers.remove(fullQuestionKey);
    } else {
      _answers[fullQuestionKey] = _Answer(updated, 'multi_correct');
    }
    notifyListeners();
  }

  void updateTextAnswer(String questionKey, String value) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    final question = _section?.questions.firstWhere(
      (q) => q.questionKey == questionKey,
      orElse: () => _section!.questions.first,
    );

    if (value.trim().isEmpty) {
      _answers.remove(fullQuestionKey);
    } else {
      _answers[fullQuestionKey] = _Answer(
        value.trim(),
        question?.type ?? 'short_text',
      );
    }
    notifyListeners();
  }

  String _getFullQuestionKey(String questionKey) {
    if (_section == null) return questionKey;
    if (questionKey.startsWith('${_section!.sectionKey}.')) {
      return questionKey;
    }
    return '${_section!.sectionKey}.$questionKey';
  }

  dynamic answerFor(String questionKey) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    return _answers[fullQuestionKey]?.value;
  }


  Map<String, dynamic> _buildRequestBody(String sectionKey) {
    final List<Map<String, dynamic>> answersList = [];

    // Only include answers for the current section
    _answers.forEach((questionKey, answerData) {
      // Skip answers from other sections
      if (!questionKey.startsWith('$sectionKey.')) {
        return;
      }

      final value = answerData.value;
      final type = answerData.questionType.toLowerCase();
      Map<String, dynamic> answerObject;

      if (type.contains('multi')) {
        // Multi-choice
        answerObject = {
          "selectedOptionKeys": (value as Set<String>).toList(),
          "otherText": null,
        };
      } else if (type.contains('single')) {
        // Single-choice
        answerObject = {"selectedOptionKey": value, "otherText": null};
      } else if (type.contains('numeric')) {
        // Numeric - convert string to number
        final numValue = num.tryParse(value.toString());
        answerObject = {"value": numValue ?? value};
      } else {
        // Short text
        answerObject = {"value": value};
      }

      answersList.add({"questionKey": questionKey, "answer": answerObject});
    });

    return {"answers": answersList, "markCompleted": true};
  }

  Future<void> saveSection(String sectionKey) async {
    final url =
        '$baseUrl/questionnaires/$template/sections/$sectionKey/response?userId=$userId';

    final body = _buildRequestBody(sectionKey); // Pass sectionKey to filter

    // Pretty print for easier debugging
    final encoder = JsonEncoder.withIndent('  ');
    log("REQUEST BODY:\n${encoder.convert(body)}");

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    log("RESPONSE ${response.statusCode}");
    if (response.body.isNotEmpty) {
      log("RESPONSE BODY: ${response.body}");
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save section: ${response.body}');
    }
  }
}
