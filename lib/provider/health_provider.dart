import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthProvider extends ChangeNotifier {
  final Health _health;
  bool _isAuthorized = false;
  bool _isLoading = false;
  HealthConnectSdkStatus? _healthConnectStatus;

  HealthProvider() : _health = Health() {
    _initialize();
  }

  // Getters
  Health get health => _health;
  bool get isAuthorized => _isAuthorized;
  bool get isLoading => _isLoading;
  HealthConnectSdkStatus? get healthConnectStatus => _healthConnectStatus;

  // Platform-specific data types
  List<HealthDataType> get types {
    if (Platform.isAndroid) {
      return [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.WORKOUT,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BLOOD_OXYGEN,
      ];
    } else {
      return [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_WALKING_RUNNING,
        HealthDataType.WORKOUT,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BLOOD_OXYGEN,
      ];
    }
  }

  // Permissions for each type
  List<HealthDataAccess> get permissions => types
      .map(
        (type) => [
          HealthDataType.GENDER,
          HealthDataType.BLOOD_TYPE,
          HealthDataType.BIRTH_DATE,
        ].contains(type)
            ? HealthDataAccess.READ
            : HealthDataAccess.READ_WRITE,
      )
      .toList();

  /// Initialize health instance
  Future<void> _initialize() async {
    await _health.configure();
    if (Platform.isAndroid) {
      await checkHealthConnectStatus();
    } else {
      await authorize();
    }
  }

  /// Check Health Connect status on Android
  Future<void> checkHealthConnectStatus() async {
    if (!Platform.isAndroid) return;

    _isLoading = true;
    notifyListeners();

    try {
      final status = await _health.getHealthConnectSdkStatus();
      _healthConnectStatus = status;
      debugPrint("Health Connect Status: $status");

      if (status == HealthConnectSdkStatus.sdkAvailable) {
        await authorize();
      }
    } catch (error) {
      debugPrint("Error checking Health Connect status: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Install Health Connect
  Future<void> installHealthConnect() async {
    try {
      await _health.installHealthConnect();
      await Future.delayed(const Duration(seconds: 2));
      await checkHealthConnectStatus();
    } catch (error) {
      debugPrint("Error installing Health Connect: $error");
      await openPlayStore();
    }
  }

  /// Open Play Store to Health Connect page
  Future<void> openPlayStore() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (error) {
      debugPrint("Error opening Play Store: $error");
    }
  }

  /// Check if permissions are granted
  Future<bool> hasPermissions() async {
    try {
      final hasPerms = await _health.hasPermissions(
        types,
        permissions: permissions,
      );
      return hasPerms ?? false;
    } catch (error) {
      debugPrint("Error checking permissions: $error");
      return false;
    }
  }

  /// Authorize and request permissions
  Future<bool> authorize() async {
    _isLoading = true;
    notifyListeners();

    // Request device permissions
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPerms = await _health.hasPermissions(
      types,
      permissions: permissions,
    );

    bool authorized = false;
    if (hasPerms == false || hasPerms == null) {
      try {
        authorized = await _health.requestAuthorization(
          types,
          permissions: permissions,
        );
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    } else {
      authorized = true;
    }

    _isAuthorized = authorized;
    _isLoading = false;
    notifyListeners();

    return authorized;
  }

  /// Get total steps for a time interval
  Future<int?> getStepsInInterval(DateTime start, DateTime end) async {
    try {
      return await _health.getTotalStepsInInterval(
        start,
        end,
        includeManualEntry: true,
      );
    } catch (error) {
      debugPrint("Error getting steps: $error");
      return null;
    }
  }

  /// Get health data from types
  Future<List<HealthDataPoint>> getHealthData({
    required List<HealthDataType> types,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      return await _health.getHealthDataFromTypes(
        types: types,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (error) {
      debugPrint("Error getting health data: $error");
      return [];
    }
  }

  /// Remove duplicate health data points
  List<HealthDataPoint> removeDuplicates(List<HealthDataPoint> data) {
    return _health.removeDuplicates(data);
  }
}
