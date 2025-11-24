import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';

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
  HealthConnectSdkStatus? _healthConnectStatus;

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

  // Data types to fetch - platform specific
  List<HealthDataType> get types {
    if (Platform.isAndroid) {
      return [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_DELTA, // Android uses DISTANCE_DELTA
        HealthDataType.WORKOUT,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BLOOD_OXYGEN,
      ];
    } else {
      return [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_WALKING_RUNNING, // iOS specific
        HealthDataType.WORKOUT,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BLOOD_OXYGEN,
      ];
    }
  }

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
    _checkHealthConnectStatus();
  }

  /// Check Health Connect status on Android
  Future<void> _checkHealthConnectStatus() async {
    if (Platform.isAndroid) {
      setState(() => _isLoading = true);

      try {
        final status = await health.getHealthConnectSdkStatus();
        setState(() {
          _healthConnectStatus = status;
        });

        debugPrint("Health Connect Status: $status");

        // If Health Connect is available, proceed with authorization
        if (status == HealthConnectSdkStatus.sdkAvailable) {
          await _authorize();
        }
      } catch (error) {
        debugPrint("Error checking Health Connect status: $error");
      }

      setState(() => _isLoading = false);
    } else {
      // iOS - proceed directly to authorization
      await _authorize();
    }
  }

  /// Install Health Connect
  Future<void> _installHealthConnect() async {
    try {
      await health.installHealthConnect();
      // Recheck status after installation attempt
      await Future.delayed(const Duration(seconds: 2));
      await _checkHealthConnectStatus();
    } catch (error) {
      debugPrint("Error installing Health Connect: $error");
      // Fallback: Open Play Store directly
      _openPlayStore();
    }
  }

  /// Open Play Store to Health Connect page
  Future<void> _openPlayStore() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (error) {
      debugPrint("Error opening Play Store: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please install Health Connect from Play Store'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
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
          case HealthDataType.DISTANCE_DELTA:
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
            case HealthDataType.DISTANCE_DELTA:
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

  /// Build Health Connect installation prompt for Android
  Widget _buildHealthConnectPrompt() {
    String message;
    String buttonText;
    IconData icon;

    switch (_healthConnectStatus) {
      case HealthConnectSdkStatus.sdkUnavailable:
        message = 'Health Connect is not available on your device';
        buttonText = 'Learn More';
        icon = Icons.info_outline;
        break;
      case HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired:
        message = 'Please update Google Play Services to use Health Connect';
        buttonText = 'Update';
        icon = Icons.system_update;
        break;
      default:
        message = 'Health Connect is required to access fitness data';
        buttonText = 'Install Health Connect';
        icon = Icons.download;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: Colors.teal),
            ),
            const SizedBox(height: 24),
            const Text(
              'Health Connect Required',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _installHealthConnect,
              icon: const Icon(Icons.download),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _checkHealthConnectStatus,
              child: const Text('I\'ve already installed it'),
            ),
          ],
        ),
      ),
    );
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
              if (Platform.isAndroid) {
                _checkHealthConnectStatus();
              } else {
                _fetchFitnessData();
                _fetchWeeklyData();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Platform.isAndroid &&
                _healthConnectStatus != HealthConnectSdkStatus.sdkAvailable
          ? _buildHealthConnectPrompt()
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
                            picpath: "",
                            icon: Icons.directions_walk,
                            title: 'Steps',
                            value: _steps.toString(),
                            unit: 'steps',
                            color: Colors.blue,
                          ),
                          _buildFitnessCard(
                            picpath: "",
                            icon: Icons.favorite,
                            title: 'Heart Rate',
                            value: _heartRate > 0
                                ? _heartRate.toString()
                                : '--',
                            unit: 'bpm',
                            color: Colors.red,
                          ),
                          _buildFitnessCard(
                            picpath: "",
                            icon: Icons.local_fire_department,
                            title: 'Calories',
                            value: _calories.toStringAsFixed(0),
                            unit: 'kcal',
                            color: Colors.orange,
                          ),
                          _buildFitnessCard(
                            picpath: "",
                            icon: Icons.route,
                            title: 'Distance',
                            value: _distance.toStringAsFixed(2),
                            unit: 'km',
                            color: Colors.green,
                          ),
                          _buildFitnessCard(
                            picpath: "",
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
                            picpath: "",
                          ),
                          _buildFitnessCard(
                            picpath: "",
                            icon: Icons.air,
                            title: 'VO2 Max',
                            value: _vo2Max > 0
                                ? _vo2Max.toStringAsFixed(1)
                                : '--',
                            unit: 'ml/kg/min',
                            color: Colors.cyan,
                          ),
                          _buildFitnessCard(
                            picpath: "",
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
        // elevation: 4,
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
    required String picpath,
  }) {
    return Card(
      // shadowColor: color.withValues(alpha: 0.4),
      // elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   // colors: [Colors.white, color.withOpacity(0.08)],
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                unit,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            // Value and Unit

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.baseline,
            //   textBaseline: TextBaseline.alphabetic,
            //   children: [
            //     Flexible(
            //       child: Text(
            //         value,
            //         style: const TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.w900,
            //           color: Colors.black,
            //         ),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //     const SizedBox(width: 4),
            //     Text(
            //       unit,
            //       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
