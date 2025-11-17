import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:walnut_home_page/provider/health_provider.dart';


class WearablesDailyChangeIndicatorCards extends StatefulWidget {
  const WearablesDailyChangeIndicatorCards({Key? key}) : super(key: key);

  @override
  State<WearablesDailyChangeIndicatorCards> createState() =>
      _WearablesDailyChangeIndicatorCardsState();
}

class _WearablesDailyChangeIndicatorCardsState
    extends State<WearablesDailyChangeIndicatorCards> {
  Map<String, Map<String, dynamic>> _changes = {};
  bool _isLoading = true;
  late Health health;
  bool _hasInitialized = false; // Add this flag

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      // Get health instance from provider
      health = HealthProvider.of(context);
      _hasInitialized = true;
      
      // Add a small delay to ensure authorization is complete
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _fetchDailyChanges();
        }
      });
    }
  }

  Future<void> _fetchDailyChanges() async {
    setState(() => _isLoading = true);

    try {
      // Check if we have permissions first
      final hasPermissions = await health.hasPermissions(
        [
          HealthDataType.STEPS,
          HealthDataType.HEART_RATE,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.DISTANCE_DELTA,
          HealthDataType.SLEEP_ASLEEP,
        ],
      );

      if (hasPermissions == false || hasPermissions == null) {
        debugPrint("No health permissions granted yet");
        setState(() => _isLoading = false);
        return;
      }

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final yesterdayStart = DateTime(now.year, now.month, now.day - 1);
      final yesterdayEnd = DateTime(
        now.year,
        now.month,
        now.day - 1,
        23,
        59,
        59,
      );

      // Get today's steps
      int? todaySteps = await health.getTotalStepsInInterval(
        todayStart,
        now,
        includeManualEntry: true,
      );

      // Get yesterday's steps
      int? yesterdaySteps = await health.getTotalStepsInInterval(
        yesterdayStart,
        yesterdayEnd,
        includeManualEntry: true,
      );

      debugPrint("Today Steps: $todaySteps, Yesterday Steps: $yesterdaySteps");

      // Get today's health data
      List<HealthDataPoint> todayData = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.HEART_RATE,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          Platform.isAndroid 
              ? HealthDataType.DISTANCE_DELTA 
              : HealthDataType.DISTANCE_WALKING_RUNNING,
          HealthDataType.SLEEP_ASLEEP,
        ],
        startTime: todayStart,
        endTime: now,
      );

      // Get yesterday's health data
      List<HealthDataPoint> yesterdayData = await health.getHealthDataFromTypes(
        types: [
          HealthDataType.HEART_RATE,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          Platform.isAndroid 
              ? HealthDataType.DISTANCE_DELTA 
              : HealthDataType.DISTANCE_WALKING_RUNNING,
          HealthDataType.SLEEP_ASLEEP,
        ],
        startTime: yesterdayStart,
        endTime: yesterdayEnd,
      );

      debugPrint("Today Data Points: ${todayData.length}, Yesterday Data Points: ${yesterdayData.length}");

      // Process data
      Map<String, double> todayValues = _processHealthData(todayData);
      Map<String, double> yesterdayValues = _processHealthData(yesterdayData);

      // Calculate changes
      Map<String, Map<String, dynamic>> changes = {};

      // Steps
      if (todaySteps != null && yesterdaySteps != null && yesterdaySteps > 0) {
        changes['Steps'] = _calculateChange(
          todaySteps.toDouble(),
          yesterdaySteps.toDouble(),
          'steps',
          Icons.directions_walk,
          Colors.blue,
        );
      }

      // Heart Rate
      if (todayValues['heartRate']! > 0 && yesterdayValues['heartRate']! > 0) {
        changes['Heart Rate'] = _calculateChange(
          todayValues['heartRate']!,
          yesterdayValues['heartRate']!,
          'bpm',
          Icons.favorite,
          Colors.red,
        );
      }

      // Calories
      if (todayValues['calories']! > 0 && yesterdayValues['calories']! > 0) {
        changes['Calories'] = _calculateChange(
          todayValues['calories']!,
          yesterdayValues['calories']!,
          'kcal',
          Icons.local_fire_department,
          Colors.orange,
        );
      }

      // Distance
      if (todayValues['distance']! > 0 && yesterdayValues['distance']! > 0) {
        changes['Distance'] = _calculateChange(
          todayValues['distance']! / 1000,
          yesterdayValues['distance']! / 1000,
          'km',
          Icons.route,
          Colors.green,
        );
      }

      // Sleep
      if (todayValues['sleep']! > 0 && yesterdayValues['sleep']! > 0) {
        changes['Sleep'] = _calculateChange(
          todayValues['sleep']! / 60,
          yesterdayValues['sleep']! / 60,
          'hrs',
          Icons.nightlight_round,
          Colors.indigo,
        );
      }

      debugPrint("Total changes found: ${changes.length}");

      setState(() {
        _changes = changes;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint("Error fetching daily changes: $error");
      setState(() => _isLoading = false);
    }
  }

  Map<String, double> _processHealthData(List<HealthDataPoint> data) {
    double calories = 0;
    double distance = 0;
    double heartRate = 0;
    double sleep = 0;

    for (var point in data) {
      double? value;
      if (point.value is NumericHealthValue) {
        value = (point.value as NumericHealthValue).numericValue.toDouble();
      }

      if (value != null) {
        switch (point.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += value;
            break;
          case HealthDataType.DISTANCE_DELTA:
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            distance += value;
            break;
          case HealthDataType.HEART_RATE:
            heartRate = value;
            break;
          case HealthDataType.SLEEP_ASLEEP:
            sleep += value;
            break;
          default:
            break;
        }
      }
    }

    return {
      'calories': calories,
      'distance': distance,
      'heartRate': heartRate,
      'sleep': sleep,
    };
  }
  Map<String, dynamic> _calculateChange(
    double today,
    double yesterday,
    String unit,
    IconData icon,
    Color color,
  ) {
    double change = today - yesterday;
    double percentChange = yesterday != 0 ? (change / yesterday) * 100 : 0;
    bool isIncrease = change > 0;

    return {
      'today': today,
      'change': change.abs(),
      'percentChange': percentChange.abs(),
      'isIncrease': isIncrease,
      'unit': unit,
      'icon': icon,
      'color': color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Daily Changes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _changes.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _changes.length,
                      itemBuilder: (context, index) {
                        final entry = _changes.entries.elementAt(index);
                        return DailyChangeCard(
                          title: entry.key,
                          data: entry.value,
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class DailyChangeCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  const DailyChangeCard({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncrease = data['isIncrease'] as bool;
    final color = data['color'] as Color;
    final icon = data['icon'] as IconData;
    final today = data['today'] as double;
    final change = data['change'] as double;
    final percentChange = data['percentChange'] as double;
    final unit = data['unit'] as String;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and Title Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Today's Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    today.toStringAsFixed(
                      unit == 'km' || unit == 'hrs' ? 1 : 0,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Change Indicator
              Row(
                children: [
                  Icon(
                    isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isIncrease ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change.toStringAsFixed(unit == 'km' || unit == 'hrs' ? 1 : 0)} (${percentChange.toStringAsFixed(0)}%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}