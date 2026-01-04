import 'package:flutter/material.dart';
import 'package:walnut_home_page/models/weekly_tasks_info.dart';

WeeklyPlan getDummyWeeklyPlan() {
  return WeeklyPlan(
    weekNumber: 24,
    dateRange: 'Oct 24 - 30',
    isAIGenerated: true,
    theme: WeekTheme(
      title: 'Metabolic Flexibility',
      description:
          'Shift focus to intermittent fasting windows to improve insulin sensitivity and energy stability.',
      basedOn: 'Based on last week\'s recovery data (HRV 42ms)',
      icon: Icons.bolt,
    ),
    targets: [
      WeeklyTarget(
        label: 'Zone 2 Cardio',
        value: '120',
        unit: 'mins',
        progress: 0.35,
        icon: Icons.favorite_outline,
        currentValue: 42,
        targetValue: 120,
      ),
      WeeklyTarget(
        label: 'Protein',
        value: '150',
        unit: 'g/day',
        progress: 0.80,
        icon: Icons.restaurant,
        currentValue: 120,
        targetValue: 150,
      ),
    ],
    focusAreas: [
      FocusArea(
        name: 'Sleep',
        subtitle: 'Avg 7.5h+',
        icon: Icons.bedtime,
        color: Colors.indigo,
        isHighlighted: false,
        additionalInfo: 'Maintain consistent sleep schedule',
      ),
      FocusArea(
        name: 'Nutrition',
        subtitle: 'Carbs <50g',
        icon: Icons.restaurant,
        color: const Color(0xFF11D4D4),
        isHighlighted: true,
        additionalInfo: 'Low-carb ketogenic approach',
      ),
      FocusArea(
        name: 'Movement',
        subtitle: 'Zone 2',
        icon: Icons.directions_run,
        color: Colors.orange,
        isHighlighted: false,
        additionalInfo: 'Aerobic base building',
      ),
      FocusArea(
        name: 'Stress',
        subtitle: 'HRV >45ms',
        icon: Icons.self_improvement,
        color: Colors.red,
        isHighlighted: false,
        additionalInfo: 'Recovery and meditation focus',
      ),
    ],
    goals: [
      WeeklyGoal(
        title: 'Complete 3 Zone 2 Cardio sessions',
        subtitle: '1/3 Completed',
        isCompleted: false,
        type: GoalType.recurring,
      ),
      WeeklyGoal(
        title: 'Maintain 16:8 fasting window',
        subtitle: 'Target: 5/7 days',
        isCompleted: false,
        type: GoalType.recurring,
      ),
      WeeklyGoal(
        title: 'Supplements Stack Review',
        subtitle: 'Completed Monday',
        isCompleted: true,
        type: GoalType.milestone,
      ),
    ],
    successVision: SuccessVision(
      title: 'Success vision for Sunday',
      description:
          '"By Sunday, you should feel higher energy in mornings and lower cravings post-dinner due to stabilized glucose levels."',
      icon: Icons.flag,
    ),
  );
}

final weeklyplan = getDummyWeeklyPlan();
