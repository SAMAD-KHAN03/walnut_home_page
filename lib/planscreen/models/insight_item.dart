
import 'package:flutter/widgets.dart';

/// Data for a single Insight or Graph Placeholder
class InsightItem {
  final String type; // 'KeyInsight' or 'Graph'
  final String title;
  final String? description;
  final IconData icon;

  InsightItem({
    required this.type,
    required this.title,
    this.description,
    required this.icon,
  });
}
