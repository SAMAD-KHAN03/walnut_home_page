
import 'dart:convert';
import 'package:http/http.dart' as http;

enum QuestionnaireSection {
  basicProfile,
  lifestyleRoutine,
  currentHealthChallenges,
  previousCareExperiences,
  primaryGoals,
  careerLifeFinancialAspirations,
  personalLifeRelationshipHealth,
  longevityBiohackingMindset,
  yourCommitment,
}

extension QuestionnaireSectionX on QuestionnaireSection {
  String get sectionKey {
    switch (this) {
      case QuestionnaireSection.basicProfile:
        return 'basic_profile';
      case QuestionnaireSection.lifestyleRoutine:
        return 'lifestyle_routine';
      case QuestionnaireSection.currentHealthChallenges:
        return 'current_health_challenges';
      case QuestionnaireSection.previousCareExperiences:
        return 'previous_care_experiences';
      case QuestionnaireSection.primaryGoals:
        return 'primary_goals';
      case QuestionnaireSection.careerLifeFinancialAspirations:
        return 'career_life_financial_aspirations';
      case QuestionnaireSection.personalLifeRelationshipHealth:
        return 'personal_life_relationship_health';
      case QuestionnaireSection.longevityBiohackingMindset:
        return 'longevity_biohacking_mindset';
      case QuestionnaireSection.yourCommitment:
        return 'your_commitment';
    }
  }

  String get title {
    switch (this) {
      case QuestionnaireSection.basicProfile:
        return 'Basic Profile';
      case QuestionnaireSection.lifestyleRoutine:
        return 'Lifestyle & Routine';
      case QuestionnaireSection.currentHealthChallenges:
        return 'Current Health Challenges';
      case QuestionnaireSection.previousCareExperiences:
        return 'Previous Care Experiences';
      case QuestionnaireSection.primaryGoals:
        return 'Primary Goals';
      case QuestionnaireSection.careerLifeFinancialAspirations:
        return 'Career / Life / Financial Aspirations';
      case QuestionnaireSection.personalLifeRelationshipHealth:
        return 'Personal Life & Relationship Health';
      case QuestionnaireSection.longevityBiohackingMindset:
        return 'Longevity Biohacking Mindset';
      case QuestionnaireSection.yourCommitment:
        return 'Your Commitment';
    }
  }
}
class QuestionnaireApi {
  static const String baseUrl = 'http://10.0.7.129:8080/api/v1';
  static const String template = 'health_intake';
  static const int version = 1;

  static Future<Map<String, dynamic>> fetchSection(
    QuestionnaireSection section,
  ) async {
    final url =
        '$baseUrl/questionnaires/templates/$template/versions/$version/sections/${section.sectionKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load ${section.sectionKey}');
    }

    return json.decode(response.body);
  }
}
class SectionResponse {
  final String sectionKey;
  final String title;
  final List<Question> questions;

  SectionResponse({
    required this.sectionKey,
    required this.title,
    required this.questions,
  });

  factory SectionResponse.fromJson(Map<String, dynamic> json) {
    return SectionResponse(
      sectionKey: json['sectionKey'],
      title: json['title'],
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}

class Question {
  final String questionKey;
  final String title;
  final String type;
  final bool required;
  final List<Option> options;

  Question({
    required this.questionKey,
    required this.title,
    required this.type,
    required this.required,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionKey: json['questionKey'],
      title: json['title'],
      type: json['type'],
      required: json['required'],
      options: (json['options'] as List)
          .map((e) => Option.fromJson(e))
          .toList(),
    );
  }
}

class Option {
  final String optionKey;
  final String label;

  Option({
    required this.optionKey,
    required this.label,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionKey: json['optionKey'],
      label: json['label'],
    );
  }
}