import 'package:walnut_home_page/models/adjustment_item.dart';
import 'package:walnut_home_page/models/insight_item.dart';
import 'package:walnut_home_page/models/protocol_overview.dart';
import 'package:walnut_home_page/models/timeline_day.dart';

class ProtocolEngineTask {
  final String title;
  final double progress;
  final String phase;
  final String phaseDetail;
  final ProtocolOverview overview;
  final List<TimelineDay> timeline;
  final List<AdjustmentItem> adjustments;
  final List<InsightItem> insights;

  ProtocolEngineTask({
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
