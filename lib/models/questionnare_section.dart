
class QuestionnareSection {
  final String sectionKey;
  final String title;
  final List<Question> questions;

  QuestionnareSection({
    required this.sectionKey,
    required this.title,
    required this.questions,
  });

  factory QuestionnareSection.fromJson(Map<String, dynamic> json) {
    return QuestionnareSection(
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