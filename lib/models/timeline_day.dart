import 'package:flutter/widgets.dart';

class TimelineDay {
  final String date;
  final String status;
  final int taskCount;
  final Color statusColor;
  final Color statusBgColor;

  TimelineDay({
    required this.date,
    required this.status,
    required this.taskCount,
    required this.statusColor,
    required this.statusBgColor,
  });
}
