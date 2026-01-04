import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walnut_home_page/models/questionnaire.dart';
import 'package:lottie/lottie.dart';

class QuestionnaireSectionScreen extends StatefulWidget {
  final String sectionKey;

  const QuestionnaireSectionScreen({super.key, required this.sectionKey});

  @override
  State<QuestionnaireSectionScreen> createState() =>
      _QuestionnaireSectionScreenState();
}

class _QuestionnaireSectionScreenState
    extends State<QuestionnaireSectionScreen> {
  late Future<SectionResponse> _future;
  final Map<String, dynamic> _answers = {};

  static const baseUrl = 'http://10.0.7.129:8080/api/v1';
  static const template = 'health_intake';
  static const version = 1;
  final userid = "f6633ebb-2c3d-410d-8ff6-68fc9e84a15a";
  @override
  void initState() {
    super.initState();
    _future = _fetchSection();
  }

  Future<SectionResponse> _fetchSection() async {
    final url =
        '$baseUrl/questionnaires/templates/$template/versions/$version/sections/${widget.sectionKey}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load section');
    }

    return SectionResponse.fromJson(json.decode(response.body));
  }

  Map<String, dynamic> _buildRequestBody() {
    final List<Map<String, dynamic>> answersList = [];

    _answers.forEach((questionKey, value) {
      if (value == null) return;

      // 🔹 MULTI_CHOICE
      if (value is Set<String>) {
        answersList.add({
          "questionKey": questionKey,
          "answer": {"selectedOptionKeys": value.toList(), "otherText": null},
        });
      }
      // 🔹 SHORT_TEXT (number)
      else if (value is String && int.tryParse(value) != null) {
        answersList.add({
          "questionKey": questionKey,
          "answer": {"value": int.parse(value)},
        });
      }
      // 🔹 SHORT_TEXT (string)
      else if (value is String && value.contains(' ')) {
        answersList.add({
          "questionKey": questionKey,
          "answer": {"value": value},
        });
      }
      // 🔹 SINGLE_CHOICE
      else {
        answersList.add({
          "questionKey": questionKey,
          "answer": {"selectedOptionKey": value, "otherText": null},
        });
      }
    });

    return {"answers": answersList, "markCompleted": true};
  }

  Widget _buildMultiChoice(Question question) {
    final selected = (_answers[question.questionKey] as Set<String>?) ?? {};

    return Column(
      children: question.options.map((option) {
        final isChecked = selected.contains(option.optionKey);

        return CheckboxListTile(
          value: isChecked,
          title: Text(option.label),
          onChanged: (checked) {
            setState(() {
              final updated = Set<String>.from(selected);
              if (checked == true) {
                updated.add(option.optionKey);
              } else {
                updated.remove(option.optionKey);
              }
              _answers[question.questionKey] = updated;
            });
          },
        );
      }).toList(),
    );
  }

  void _saveSection() async {
    final postUrl =
        '$baseUrl/questionnaires/$template/sections/${widget.sectionKey}/response?userId=$userid';

    final requestBody = _buildRequestBody();

    log("REQUEST BODY → ${jsonEncode(requestBody)}");

    final response = await http.put(
      Uri.parse(postUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    log("RESPONSE CODE → ${response.statusCode}");
    log("RESPONSE BODY → ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Section saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save section')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Questionnaire'),
        backgroundColor: Colors.white,
        // foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Lottie.asset(
                'assets/animations/health_bg.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          FutureBuilder<SectionResponse>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              final section = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          section.title,
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        ...section.questions.map(_buildQuestion),
                      ],
                    ),
                  ),

                  // 🔹 SAVE BUTTON
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveSection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent.shade400,
                          ),
                          child: const Text(
                            'SAVE SECTION',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(Question question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title,
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          if (question.type == 'MULTI_CHOICE') _buildMultiChoice(question),

          if (question.type == 'SINGLE_CHOICE') _buildSingleChoice(question),

          if (question.type == 'SHORT_TEXT') _buildShortText(question),
        ],
      ),
    );
  }

  Widget _buildShortText(Question question) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        // fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (value) {
        _answers[question.questionKey] = value;
      },
    );
  }

  Widget _buildSingleChoice(Question question) {
    return Column(
      children: question.options.map((option) {
        return RadioListTile<String>(
          value: option.optionKey,
          groupValue: _answers[question.questionKey],
          onChanged: (value) {
            setState(() {
              _answers[question.questionKey] = value;
            });
          },
          title: Text(
            option.label,
            // style: const TextStyle(color: Colors.white),
          ),
          activeColor: Colors.greenAccent,
        );
      }).toList(),
    );
  }
}
