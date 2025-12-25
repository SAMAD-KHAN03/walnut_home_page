// Data Models
import 'package:flutter/material.dart';

enum TaskSection { morning, nutrition, movement, evening }

class DailyTasks {
  final String title;
  final String? duration;
  final String? category;
  final String? description;
  final List<String>? tags;
  bool isCompleted;
  final TaskSection section;
  final bool hasActions;
  final IconData? icon;
  final Color? iconColor;

  DailyTasks({
    required this.title,
    this.duration,
    this.category,
    this.description,
    this.tags,
    this.isCompleted = false,
    required this.section,
    this.hasActions = false,
    this.icon,
    this.iconColor,
  });
}
