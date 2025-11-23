import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

// Global Health instance, assumed to be available
final health = Health();

class WearablesDailyChangeIndicatorCards extends StatefulWidget {
  const WearablesDailyChangeIndicatorCards({super.key});

  @override
  State<WearablesDailyChangeIndicatorCards> createState() =>
      _WearablesDailyChangeIndicatorCardsState();
}

class _WearablesDailyChangeIndicatorCardsState
    extends State<WearablesDailyChangeIndicatorCards> {
  // Map to store changes: Key (String) -> { 'today': double, 'change': double, ... }
  Map<String, Map<String, dynamic>> _changes = {};
  bool _isLoading = true;
  bool _isAuthorized = false;

  // Data types and permissions needed for this widget
  final List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    // Use platform-specific distance
    Platform.isAndroid
        ? HealthDataType.DISTANCE_DELTA
        : HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.SLEEP_ASLEEP,
  ];

  List<HealthDataAccess> get _permissions =>
      _dataTypes.map((_) => HealthDataAccess.READ_WRITE).toList();

  @override
  void initState() {
    super.initState();
    // Fetch data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (mounted) {
        await _authorizeAndFetch();
      }
    });
  }

  // --- Authorization and Permissions Logic ---

  Future<void> _authorizeAndFetch() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // 1. Request necessary permissions
      await Permission.activityRecognition.request();
      await Permission.location.request();

      bool? hasPermissions =
          await health.hasPermissions(_dataTypes, permissions: _permissions);

      bool authorized = false;
      if (hasPermissions == false || hasPermissions == null) {
        authorized = await health.requestAuthorization(
          _dataTypes,
          permissions: _permissions,
        );
      } else {
        authorized = true;
      }

      if (mounted) {
        setState(() {
          _isAuthorized = authorized;
          _isLoading = !authorized; // Stay loading if not authorized
        });
      }

      if (authorized) {
        await _fetchDailyChanges();
      }

    } catch (error) {
      log("Authorization Error: $error");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  Future<void> _fetchDailyChanges() async {
    if (!mounted || !_isAuthorized) return;

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final yesterdayStart = DateTime(now.year, now.month, now.day - 1);
      final yesterdayEnd = todayStart.subtract(const Duration(seconds: 1)); // End of yesterday

      // Fetch data for today
      List<HealthDataPoint> todayData = await health.getHealthDataFromTypes(
        types: _dataTypes,
        startTime: todayStart,
        endTime: now,
      );

      // Fetch data for yesterday
      List<HealthDataPoint> yesterdayData = await health.getHealthDataFromTypes(
        types: _dataTypes,
        startTime: yesterdayStart,
        endTime: yesterdayEnd,
      );

      // Process and calculate changes
      Map<String, double> todayValues = _processHealthData(todayData);
      Map<String, double> yesterdayValues = _processHealthData(yesterdayData);

      // Get steps separately as they are often aggregated via getTotalStepsInInterval
      int todaySteps = await health.getTotalStepsInInterval(todayStart, now) ?? 0;
      int yesterdaySteps = await health.getTotalStepsInInterval(yesterdayStart, yesterdayEnd) ?? 0;
      
      Map<String, Map<String, dynamic>> changes = {};

      // 1. Steps
      if (todaySteps > 0 && yesterdaySteps > 0) {
        changes['Steps'] = _calculateChange(
          todaySteps.toDouble(),
          yesterdaySteps.toDouble(),
          'steps',
          Icons.directions_walk,
          Colors.blue,
        );
      }

      // 2. Heart Rate (Latest value logic in _processHealthData)
      if (todayValues['heartRate']! > 0 && yesterdayValues['heartRate']! > 0) {
        changes['Heart Rate'] = _calculateChange(
          todayValues['heartRate']!,
          yesterdayValues['heartRate']!,
          'bpm',
          Icons.favorite,
          Colors.red,
        );
      }

      // 3. Calories (Sum logic in _processHealthData)
      if (todayValues['calories']! > 0 && yesterdayValues['calories']! > 0) {
        changes['Calories'] = _calculateChange(
          todayValues['calories']!,
          yesterdayValues['calories']!,
          'kcal',
          Icons.local_fire_department,
          Colors.orange,
        );
      }

      // 4. Distance (Sum logic in _processHealthData, converted to km)
      if (todayValues['distance']! > 0 && yesterdayValues['distance']! > 0) {
        changes['Distance'] = _calculateChange(
          todayValues['distance']! / 1000,
          yesterdayValues['distance']! / 1000,
          'km',
          Icons.route,
          Colors.green,
        );
      }

      // 5. Sleep (Sum logic in _processHealthData, converted to hours)
      if (todayValues['sleep']! > 0 && yesterdayValues['sleep']! > 0) {
        changes['Sleep'] = _calculateChange(
          todayValues['sleep']! / 60,
          yesterdayValues['sleep']! / 60,
          'hrs',
          Icons.nightlight_round,
          Colors.indigo,
        );
      }

      if (mounted) {
        setState(() {
          _changes = changes;
          _isLoading = false;
        });
      }

    } catch (error) {
      log('Error fetching daily changes: $error');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
//     // Add this at the end of _fetchDailyChanges for testing
// if (_changes.isEmpty) {
//   // Mock data for testing UI
//   _changes = {
//     'Steps': {
//       'today': 5000.0,
//       'change': 500.0,
//       'percentChange': 11.1,
//       'isIncrease': true,
//       'unit': 'steps',
//       'icon': Icons.directions_walk,
//       'color': Colors.blue,
//     },
//   };
// }
  }

  /// Processes raw HealthDataPoint list into aggregated values for a given day.
  Map<String, double> _processHealthData(List<HealthDataPoint> data) {
    // Initialize with large/zero values as needed
    double calories = 0;
    double distance = 0;
    double heartRate = 0; // Will hold the *latest* heart rate found
    double sleep = 0; // Will hold total sleep duration in minutes/seconds

    // Remove duplicates to simplify aggregation
    data = health.removeDuplicates(data);

    // Sort to easily get the latest HEART_RATE
    data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

    for (var point in data) {
      double? value;
      // Extract numeric value safely
      if (point.value is NumericHealthValue) {
        value = (point.value as NumericHealthValue).numericValue.toDouble();
      } else if (point.value is num) {
        value = (point.value as num).toDouble();
      }

      if (value != null) {
        switch (point.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += value; // Sum for energy burned
            break;
          case HealthDataType.DISTANCE_DELTA:
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            distance += value; // Sum for total distance
            break;
          case HealthDataType.HEART_RATE:
            // Since data is sorted by dateFrom descending, the first one is the latest
            if (heartRate == 0) {
              heartRate = value;
            }
            break;
          case HealthDataType.SLEEP_ASLEEP:
            // Sleep data often comes as duration in seconds. Summing is appropriate here.
            sleep += value;
            break;
          default:
            break;
        }
      }
    }

    // Convert sleep from seconds to minutes (assuming it's in seconds)
    // If your sleep data is in minutes, adjust this
    sleep = sleep / 60.0;

    return {
      'calories': calories,
      'distance': distance,
      'heartRate': heartRate,
      'sleep': sleep,
    };
  }

  /// Calculates change and formats the output map
  Map<String, dynamic> _calculateChange(
    double today,
    double yesterday,
    String unit,
    IconData icon,
    Color color,
  ) {
    double change = today - yesterday;
    // Prevent division by zero
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

  // --- Build Method (Unchanged) ---

  @override
  Widget build(BuildContext context) {
    // If not authorized, show a prompt to authorize
    if (!_isAuthorized && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Access Denied',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Please grant health permissions to view daily changes.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _authorizeAndFetch,
                child: const Text('Grant Permissions'),
              ),
            ],
          ),
        ),
      );
    }

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
          height: 120,
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
                        return DailyChangeCard(title: entry.key, data: entry.value);
                      },
                    ),
        ),
      ],
    );
  }
}

// --- DailyChangeCard Widget (Unchanged) ---

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