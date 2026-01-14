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
  QuestionnareSection? _section;
  bool _loading = false;
  final Map<String, _Answer> _answers = {};

  QuestionnareSection? get section => _section;
  bool get isLoading => _loading;

  int get totalQuestions => _section?.questions.length ?? 0;
  int get answeredCount => _answers.length;

  /// Fetches both section questions and prefill data in parallel
  Future<void> fetchSection(String sectionKey) async {
    _loading = true;
    notifyListeners();

    try {
      // Fetch questions and prefill data concurrently
      final results = await Future.wait([
        _fetchQuestions(sectionKey),
        _fetchPrefillData(sectionKey),
      ]);

      final questionsResponse = results[0];
      final prefillResponse = results[1];

      // Parse questions
      if (questionsResponse.statusCode != 200) {
        throw Exception('Failed to load questionnaire section');
      }

      _section = QuestionnareSection.fromJson(
        json.decode(questionsResponse.body),
      );

      // Clear previous answers for this section
      _answers.removeWhere((key, _) => key.startsWith('$sectionKey.'));

      // Populate prefill data if available
      if (prefillResponse.statusCode == 200) {
        final prefillData = json.decode(prefillResponse.body);
        _populatePrefillData(prefillData, sectionKey);
      } else if (prefillResponse.statusCode != 404) {
        // Log warning for non-404 errors (404 is expected for new sections)
        log('Prefill data fetch failed with status ${prefillResponse.statusCode}');
      }
    } catch (e) {
      log('Error fetching section: $e');
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Fetches the section questions schema
  Future<http.Response> _fetchQuestions(String sectionKey) async {
    final url =
        '$baseUrl/questionnaires/templates/$template/versions/$version/sections/$sectionKey';
    return await http.get(Uri.parse(url));
  }

  /// Fetches the prefill data for the section
  Future<http.Response> _fetchPrefillData(String sectionKey) async {
    final url =
        '$baseUrl/questionnaires/$template/sections/$sectionKey/response?userId=$userId';
    return await http.get(Uri.parse(url));
  }

  /// Populates answers from prefill data
  void _populatePrefillData(
    Map<String, dynamic> responseData,
    String sectionKey,
  ) {
    try {
      final prefillMap = responseData['prefill'] as Map<String, dynamic>?;
      if (prefillMap == null || prefillMap.isEmpty) return;

      prefillMap.forEach((questionKey, answerData) {
        if (answerData == null) return;

        final answerMap = answerData as Map<String, dynamic>;

        // Find the question to determine its type
        final question = _section?.questions.firstWhere(
          (q) => q.questionKey == questionKey,
          orElse: () => throw Exception('Question not found: $questionKey'),
        );

        if (question == null) return;

        final questionType = question.type.toUpperCase();

        // Populate answer based on question type
        if (questionType.contains('MULTI')) {
          _populateMultiChoiceAnswer(questionKey, answerMap, question.type);
        } else if (questionType.contains('SINGLE')) {
          _populateSingleChoiceAnswer(questionKey, answerMap, question.type);
        } else if (questionType == 'NUMBER') {
          _populateNumericAnswer(questionKey, answerMap, question.type);
        } else {
          _populateTextAnswer(questionKey, answerMap, question.type);
        }
      });

      log('Prefill data loaded: ${_answers.length} answers populated');
    } catch (e) {
      log('Error populating prefill data: $e');
    }
  }

  void _populateMultiChoiceAnswer(
    String questionKey,
    Map<String, dynamic> answerMap,
    String questionType,
  ) {
    final selectedKeys = answerMap['selectedOptionKeys'] as List?;
    if (selectedKeys != null && selectedKeys.isNotEmpty) {
      final optionSet = selectedKeys.map((e) => e.toString()).toSet();
      _answers[questionKey] = _Answer(optionSet, questionType);
    }
  }

  void _populateSingleChoiceAnswer(
    String questionKey,
    Map<String, dynamic> answerMap,
    String questionType,
  ) {
    final selectedKey = answerMap['selectedOptionKey'] as String?;
    if (selectedKey != null && selectedKey.isNotEmpty) {
      _answers[questionKey] = _Answer(selectedKey, questionType);
    }
    // Note: otherText is available in answerMap['otherText'] if needed
  }

  void _populateNumericAnswer(
    String questionKey,
    Map<String, dynamic> answerMap,
    String questionType,
  ) {
    final value = answerMap['value'];
    if (value != null) {
      // Store as string for consistency with text input
      _answers[questionKey] = _Answer(value.toString(), questionType);
    }
  }

  void _populateTextAnswer(
    String questionKey,
    Map<String, dynamic> answerMap,
    String questionType,
  ) {
    final value = answerMap['value'];
    if (value != null) {
      final stringValue = value.toString();
      if (stringValue.isNotEmpty) {
        _answers[questionKey] = _Answer(stringValue, questionType);
      }
    }
  }

  // Update handlers
  void updateSingleChoice(String questionKey, String optionKey) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    final question = _findQuestion(questionKey);
    _answers[fullQuestionKey] = _Answer(optionKey, question?.type ?? 'SINGLE_CHOICE');
    notifyListeners();
  }

  void updateMultiChoice(String questionKey, String optionKey, bool selected) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    final question = _findQuestion(questionKey);
    final current = _answers[fullQuestionKey]?.value as Set<String>? ?? <String>{};

    final updated = Set<String>.from(current);
    selected ? updated.add(optionKey) : updated.remove(optionKey);

    if (updated.isEmpty) {
      _answers.remove(fullQuestionKey);
    } else {
      _answers[fullQuestionKey] = _Answer(updated, question?.type ?? 'MULTI_CHOICE');
    }
    notifyListeners();
  }

  void updateTextAnswer(String questionKey, String value) {
    final fullQuestionKey = _getFullQuestionKey(questionKey);
    final question = _findQuestion(questionKey);

    if (value.trim().isEmpty) {
      _answers.remove(fullQuestionKey);
    } else {
      _answers[fullQuestionKey] = _Answer(
        value.trim(),
        question?.type ?? 'SHORT_TEXT',
      );
    }
    notifyListeners();
  }

  Question? _findQuestion(String questionKey) {
    return _section?.questions.firstWhere(
      (q) => q.questionKey == questionKey,
      orElse: () => _section!.questions.first,
    );
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

    _answers.forEach((questionKey, answerData) {
      // Only include answers for the current section
      if (!questionKey.startsWith('$sectionKey.')) return;

      final value = answerData.value;
      final type = answerData.questionType.toUpperCase();
      Map<String, dynamic> answerObject;

      if (type.contains('MULTI')) {
        answerObject = {
          "selectedOptionKeys": (value as Set<String>).toList(),
          "otherText": null,
        };
      } else if (type.contains('SINGLE')) {
        answerObject = {
          "selectedOptionKey": value,
          "otherText": null,
        };
      } else if (type == 'NUMBER') {
        final numValue = num.tryParse(value.toString());
        answerObject = {"value": numValue ?? value};
      } else {
        answerObject = {"value": value};
      }

      answersList.add({
        "questionKey": questionKey,
        "answer": answerObject,
      });
    });

    return {
      "answers": answersList,
      "markCompleted": true,
    };
  }

  Future<void> saveSection(String sectionKey) async {
    final url =
        '$baseUrl/questionnaires/$template/sections/$sectionKey/response?userId=$userId';

    final body = _buildRequestBody(sectionKey);

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

  /// Clears all data when provider is disposed or reset
  void reset() {
    _section = null;
    _answers.clear();
    _loading = false;
  }

  @override
  void dispose() {
    _answers.clear();
    super.dispose();
  }
}