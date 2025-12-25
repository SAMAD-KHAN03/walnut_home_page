import 'package:walnut_home_page/models/daily_task.dart';
import 'package:flutter/material.dart';

final dailytasks = [
  DailyTasks(
    title: 'Sunlight Exposure',
    duration: '15 min',
    category: 'Circadian Entrainment',
    isCompleted: true,
    section: TaskSection.morning,
  ),
  DailyTasks(
    title: 'Hydration Protocol',
    duration: '500ml + Electrolytes',
    category: 'Within 30 mins of waking',
    isCompleted: false,
    section: TaskSection.morning,
    hasActions: true,
    icon: Icons.water_drop,
    iconColor: Colors.blue,
  ),
  DailyTasks(
    title: 'First Meal',
    description: 'High protein, low glycemic index to sustain energy.',
    isCompleted: false,
    section: TaskSection.nutrition,
    tags: ['Protein Focus'],
  ),
  DailyTasks(
    title: 'Zone 2 Cardio',
    duration: '45 min',
    category: 'Mitochondrial Biogenesis',
    isCompleted: false,
    section: TaskSection.movement,
  ),
  DailyTasks(
    title: 'Blue Light Blocking',
    description: 'Wear blockers 2 hrs before sleep.',
    isCompleted: false,
    section: TaskSection.evening,
  ),
  DailyTasks(
    title: 'Magnesium Supplement',
    description: '500mg Glycinate.',
    isCompleted: false,
    section: TaskSection.evening,
  ),
];
