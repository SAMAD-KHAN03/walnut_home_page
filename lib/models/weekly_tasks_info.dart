//this will show the weekly and monthly tasks very small object on weekly protocol screen
import 'package:flutter/material.dart';

class WeeklyPlan {
  final int weekNumber;
  final String dateRange;
  final WeekTheme theme;
  final List<WeeklyTarget> targets;
  final List<FocusArea> focusAreas;
  final List<WeeklyGoal> goals;
  final SuccessVision successVision;
  final bool isAIGenerated;

  WeeklyPlan({
    required this.weekNumber,
    required this.dateRange,
    required this.theme,
    required this.targets,
    required this.focusAreas,
    required this.goals,
    required this.successVision,
    this.isAIGenerated = true,
  });

  // Calculate overall completion percentage
  double get completionPercentage {
    if (goals.isEmpty) return 0.0;
    final completed = goals.where((g) => g.isCompleted).length;
    return completed / goals.length;
  }

  // Get number of completed goals
  int get completedGoalsCount {
    return goals.where((g) => g.isCompleted).length;
  }
}
class WeekTheme {
  final String title;
  final String description;
  final String basedOn;
  final IconData icon;

  WeekTheme({
    required this.title,
    required this.description,
    required this.basedOn,
    this.icon = Icons.bolt,
  });
}

class WeeklyTarget {
  final String label;
  final String value;
  final String unit;
  final double progress; // 0.0 to 1.0
  final IconData icon;
  final int currentValue;
  final int targetValue;

  WeeklyTarget({
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.icon,
    required this.currentValue,
    required this.targetValue,
  });

  String get progressText => '$currentValue / $targetValue';
}

class FocusArea {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isHighlighted;
  final String? additionalInfo;

  FocusArea({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
    this.additionalInfo,
  });
}

class WeeklyGoal {
  final String title;
  final String subtitle;
  bool isCompleted;
  final GoalType type;

  WeeklyGoal({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.type = GoalType.regular,
  });
}

enum GoalType {
  regular,
  recurring,
  milestone,
}

class SuccessVision {
  final String title;
  final String description;
  final IconData icon;

  SuccessVision({
    required this.title,
    required this.description,
    this.icon = Icons.flag,
  });
}