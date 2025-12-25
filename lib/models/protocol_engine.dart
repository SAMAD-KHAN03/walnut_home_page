import 'package:flutter/material.dart';

// Data Models
class ProtocolEngine {
  final String name;
  final String duration;
  final String startingDate;
  final String summary;
  final List<String> summaryTags;
  final List<HealthArea> healthAreas;
  final List<ProtocolPhase> protocolPhases;
  final int currentDay;
  final String personName;

  ProtocolEngine({
    required this.name,
    required this.duration,
    required this.startingDate,
    required this.summary,
    required this.summaryTags,
    required this.healthAreas,
    required this.protocolPhases,
    required this.currentDay,
    required this.personName,
  });

  // Calculate progress percentage
  double get progressPercentage {
    final totalDays = int.tryParse(duration.split(' ').first) ?? 90;
    return (currentDay / totalDays).clamp(0.0, 1.0);
  }

  // Get current phase
  ProtocolPhase? get currentPhase {
    for (var phase in protocolPhases) {
      final range = phase.getDayRange();
      if (currentDay >= range.$1 && currentDay <= range.$2) {
        return phase;
      }
    }
    return null;
  }

  // Check if phase is completed
  bool isPhaseCompleted(ProtocolPhase phase) {
    final range = phase.getDayRange();
    return currentDay > range.$2;
  }

  // Get phase progress
  double getPhaseProgress(ProtocolPhase phase) {
    final range = phase.getDayRange();
    if (currentDay < range.$1) return 0.0;
    if (currentDay > range.$2) return 1.0;
    return ((currentDay - range.$1) / (range.$2 - range.$1)).clamp(0.0, 1.0);
  }
}

class HealthArea {
  final String name;
  final String status; // Excellent, Improving, Alarming
  final String value;
  final IconData icon;
  final Color color;
  final String trend; // +4.2%, Stable, -2.1%
  final TrendType trendType; // up, flat, down

  HealthArea({
    required this.name,
    required this.status,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendType,
  });
}

enum TrendType { up, flat, down }

enum ProtocolPhaseType { foundation, acceleration, optimization }

class ProtocolPhase {
  final ProtocolPhaseType type;
  final String range; // like "Days 1-30"
  final String summary;

  ProtocolPhase({
    required this.type,
    required this.range,
    required this.summary,
  });

  String get title {
    switch (type) {
      case ProtocolPhaseType.foundation:
        return 'Foundation';
      case ProtocolPhaseType.acceleration:
        return 'Acceleration';
      case ProtocolPhaseType.optimization:
        return 'Optimization';
    }
  }

  // Extract day range from string like "Days 1-30"
  (int, int) getDayRange() {
    final numbers = range.replaceAll(RegExp(r'[^0-9-]'), '');
    final parts = numbers.split('-');
    if (parts.length == 2) {
      return (int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
    }
    return (0, 0);
  }
}