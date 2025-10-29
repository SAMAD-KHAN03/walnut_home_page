
import 'package:walnut_home_page/planscreen/models/adjustment_item.dart';
import 'package:walnut_home_page/planscreen/models/insight_item.dart';
import 'package:walnut_home_page/planscreen/models/protocol_overview.dart';
import 'package:walnut_home_page/planscreen/models/timeline_day.dart';

/// Master model containing all data for the Plan Screen
class ProtocolData {
  final String title;
  final double progress;
  final String phase;
  final String phaseDetail;
  final ProtocolOverview overview;
  final List<TimelineDay> timeline;
  final List<AdjustmentItem> adjustments;
  final List<InsightItem> insights;

  ProtocolData({
    required this.title,
    required this.progress,
    required this.phase,
    required this.phaseDetail,
    required this.overview,
    required this.timeline,
    required this.adjustments,
    required this.insights,
  });
}

