import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fl_chart/fl_chart.dart';

// Global Health instance
final health = Health();

class FitnessDataScreen extends StatefulWidget {
  const FitnessDataScreen({super.key});

  @override
  _FitnessDataScreenState createState() => _FitnessDataScreenState();
}

class _FitnessDataScreenState extends State<FitnessDataScreen> {
  bool _isLoading = false;
  bool _isAuthorized = false;

  // Today's fitness data variables
  int _steps = 0;
  double _distance = 0.0;
  double _calories = 0.0;
  int _heartRate = 0;
  int _sleepMinutes = 0;
  int _workouts = 0;
  double _vo2Max = 0.0;
  int _bloodOxygen = 0;

  // Weekly data for charts
  Map<String, List<FlSpot>> _weeklyData = {
    'steps': [],
    'heartRate': [],
    'calories': [],
    'distance': [],
    'sleep': [],
    'bloodOxygen': [],
  };

  // Data types to fetch
  final types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.WORKOUT,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.BLOOD_OXYGEN,
  ];

  // Permissions for each type
  List<HealthDataAccess> get permissions => types
      .map(
        (type) =>
            [
              HealthDataType.GENDER,
              HealthDataType.BLOOD_TYPE,
              HealthDataType.BIRTH_DATE,
            ].contains(type)
            ? HealthDataAccess.READ
            : HealthDataAccess.READ_WRITE,
      )
      .toList();

  @override
  void initState() {
    super.initState();
    health.configure();
    if (Platform.isAndroid) {
      health.getHealthConnectSdkStatus();
    }
    _authorize();
  }

  /// Authorize and request permissions
  Future<void> _authorize() async {
    setState(() => _isLoading = true);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions = await health.hasPermissions(
      types,
      permissions: permissions,
    );

    bool authorized = false;
    if (hasPermissions == false || hasPermissions == null) {
      try {
        authorized = await health.requestAuthorization(
          types,
          permissions: permissions,
        );
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    } else {
      authorized = true;
    }

    setState(() {
      _isAuthorized = authorized;
      _isLoading = false;
    });

    if (authorized) {
      _fetchFitnessData();
      _fetchWeeklyData();
    }
  }

  /// Fetch today's fitness data
  Future<void> _fetchFitnessData() async {
    if (!_isAuthorized) {
      await _authorize();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      int? steps = await health.getTotalStepsInInterval(
        midnight,
        now,
        includeManualEntry: true,
      );

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: types,
        startTime: midnight,
        endTime: now,
      );

      healthData = health.removeDuplicates(healthData);

      double totalDistance = 0;
      double totalCalories = 0;
      int latestHeartRate = 0;
      int totalSleepMinutes = 0;
      int workoutCount = 0;
      double latestVo2Max = 0;
      int latestBloodOxygen = 0;

      for (var data in healthData) {
        double? numericValue;
        if (data.value is NumericHealthValue) {
          numericValue = (data.value as NumericHealthValue).numericValue
              .toDouble();
        } else if (data.value is num) {
          numericValue = (data.value as num).toDouble();
        }

        switch (data.type) {
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            if (numericValue != null) totalDistance += numericValue;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            if (numericValue != null) totalCalories += numericValue;
            break;
          case HealthDataType.HEART_RATE:
            if (numericValue != null) latestHeartRate = numericValue.toInt();
            break;
          case HealthDataType.SLEEP_ASLEEP:
            if (numericValue != null) totalSleepMinutes += numericValue.toInt();
            break;
          case HealthDataType.WORKOUT:
            workoutCount++;
            break;
          case HealthDataType.BLOOD_OXYGEN:
            if (numericValue != null) latestBloodOxygen = numericValue.toInt();
            break;
          default:
            break;
        }
      }

      setState(() {
        _steps = steps ?? 0;
        _distance = totalDistance / 1000;
        _calories = totalCalories;
        _heartRate = latestHeartRate;
        _sleepMinutes = totalSleepMinutes;
        _workouts = workoutCount;
        _vo2Max = latestVo2Max;
        _bloodOxygen = latestBloodOxygen;
      });
    } catch (error) {
      debugPrint("Error fetching health data: $error");
    }

    setState(() => _isLoading = false);
  }

  /// Fetch weekly data for charts
  Future<void> _fetchWeeklyData() async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      Map<String, List<FlSpot>> weeklyData = {
        'steps': [],
        'heartRate': [],
        'calories': [],
        'distance': [],
        'sleep': [],
        'bloodOxygen': [],
      };

      // Fetch data for each day
      for (int i = 6; i >= 0; i--) {
        final dayEnd = DateTime(now.year, now.month, now.day - i, 23, 59, 59);
        final dayStart = DateTime(now.year, now.month, now.day - i);

        // Get steps for the day
        int? daySteps = await health.getTotalStepsInInterval(
          dayStart,
          dayEnd,
          includeManualEntry: true,
        );
        weeklyData['steps']!.add(
          FlSpot((6 - i).toDouble(), (daySteps ?? 0).toDouble()),
        );

        // Get other health data
        List<HealthDataPoint> dayData = await health.getHealthDataFromTypes(
          types: types,
          startTime: dayStart,
          endTime: dayEnd,
        );

        dayData = health.removeDuplicates(dayData);

        double dayCalories = 0;
        double dayDistance = 0;
        int dayHeartRate = 0;
        int daySleep = 0;
        int dayBloodOxygen = 0;

        for (var data in dayData) {
          double? numericValue;
          if (data.value is NumericHealthValue) {
            numericValue = (data.value as NumericHealthValue).numericValue
                .toDouble();
          } else if (data.value is num) {
            numericValue = (data.value as num).toDouble();
          }

          switch (data.type) {
            case HealthDataType.ACTIVE_ENERGY_BURNED:
              if (numericValue != null) dayCalories += numericValue;
              break;
            case HealthDataType.DISTANCE_WALKING_RUNNING:
              if (numericValue != null) dayDistance += numericValue;
              break;
            case HealthDataType.HEART_RATE:
              if (numericValue != null) dayHeartRate = numericValue.toInt();
              break;
            case HealthDataType.SLEEP_ASLEEP:
              if (numericValue != null) daySleep += numericValue.toInt();
              break;
            case HealthDataType.BLOOD_OXYGEN:
              if (numericValue != null) dayBloodOxygen = numericValue.toInt();
              break;
            default:
              break;
          }
        }

        weeklyData['calories']!.add(FlSpot((6 - i).toDouble(), dayCalories));
        weeklyData['distance']!.add(
          FlSpot((6 - i).toDouble(), dayDistance / 1000),
        );
        weeklyData['heartRate']!.add(
          FlSpot((6 - i).toDouble(), dayHeartRate.toDouble()),
        );
        weeklyData['sleep']!.add(
          FlSpot((6 - i).toDouble(), (daySleep / 60).toDouble()),
        );
        weeklyData['bloodOxygen']!.add(
          FlSpot((6 - i).toDouble(), dayBloodOxygen.toDouble()),
        );
      }

      setState(() {
        _weeklyData = weeklyData;
      });
    } catch (error) {
      debugPrint("Error fetching weekly data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Data'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchFitnessData();
              _fetchWeeklyData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isAuthorized
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Authorization Required',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Please grant permissions to access health data'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _authorize,
                    child: const Text('Grant Permissions'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _fetchFitnessData();
                await _fetchWeeklyData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weekly Charts Section
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Weekly Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          _buildChartCard(
                            'Steps',
                            _weeklyData['steps']!,
                            Colors.blue,
                            'steps',
                          ),
                          _buildChartCard(
                            'Heart Rate',
                            _weeklyData['heartRate']!,
                            Colors.red,
                            'bpm',
                          ),
                          _buildChartCard(
                            'Calories',
                            _weeklyData['calories']!,
                            Colors.orange,
                            'kcal',
                          ),
                          _buildChartCard(
                            'Distance',
                            _weeklyData['distance']!,
                            Colors.green,
                            'km',
                          ),
                          _buildChartCard(
                            'Sleep',
                            _weeklyData['sleep']!,
                            Colors.indigo,
                            'hrs',
                          ),
                          _buildChartCard(
                            'Blood O₂',
                            _weeklyData['bloodOxygen']!,
                            Colors.pink,
                            '%',
                          ),
                        ],
                      ),
                    ),

                    // Today's Stats Section
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Today\'s Stats',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Fitness Cards Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildFitnessCard(
                            icon: Icons.directions_walk,
                            title: 'Steps',
                            value: _steps.toString(),
                            unit: 'steps',
                            color: Colors.blue,
                          ),
                          _buildFitnessCard(
                            icon: Icons.favorite,
                            title: 'Heart Rate',
                            value: _heartRate > 0
                                ? _heartRate.toString()
                                : '--',
                            unit: 'bpm',
                            color: Colors.red,
                          ),
                          _buildFitnessCard(
                            icon: Icons.local_fire_department,
                            title: 'Calories',
                            value: _calories.toStringAsFixed(0),
                            unit: 'kcal',
                            color: Colors.orange,
                          ),
                          _buildFitnessCard(
                            icon: Icons.route,
                            title: 'Distance',
                            value: _distance.toStringAsFixed(2),
                            unit: 'km',
                            color: Colors.green,
                          ),
                          _buildFitnessCard(
                            icon: Icons.nightlight_round,
                            title: 'Sleep',
                            value: (_sleepMinutes ~/ 60).toString(),
                            unit: 'hours',
                            color: Colors.indigo,
                          ),
                          _buildFitnessCard(
                            icon: Icons.fitness_center,
                            title: 'Workouts',
                            value: _workouts.toString(),
                            unit: 'sessions',
                            color: Colors.purple,
                          ),
                          _buildFitnessCard(
                            icon: Icons.air,
                            title: 'VO2 Max',
                            value: _vo2Max > 0
                                ? _vo2Max.toStringAsFixed(1)
                                : '--',
                            unit: 'ml/kg/min',
                            color: Colors.cyan,
                          ),
                          _buildFitnessCard(
                            icon: Icons.water_drop,
                            title: 'Blood O₂',
                            value: _bloodOxygen > 0
                                ? _bloodOxygen.toString()
                                : '--',
                            unit: '%',
                            color: Colors.pink,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildChartCard(
    String title,
    List<FlSpot> data,
    Color color,
    String unit,
  ) {
    final hasData = data.any((spot) => spot.y > 0);

    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Last 7 days',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: hasData
                    ? LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S',
                                  ];
                                  if (value.toInt() >= 0 && value.toInt() < 7) {
                                    return Text(
                                      days[value.toInt()],
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: data,
                              isCurved: true,
                              color: color,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: color.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, color.withOpacity(0.08)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            // Value and Unit
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
