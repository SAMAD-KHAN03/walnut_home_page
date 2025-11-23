import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthAuthorizationService {
  // Data types to fetch - platform specific
  static List<HealthDataType> get types {
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
  static List<HealthDataAccess> get permissions => types
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

  /// Check if permissions are granted
  static Future<bool> hasPermissions(Health health) async {
    final hasPermissions = await health.hasPermissions(
      types,
      permissions: permissions,
    );
    return hasPermissions == true;
  }

  /// Check Health Connect status on Android
  static Future<HealthConnectSdkStatus?> checkHealthConnectStatus(
    Health health,
  ) async {
    if (Platform.isAndroid) {
      try {
        final status = await health.getHealthConnectSdkStatus();
        debugPrint("Health Connect Status: $status");
        return status;
      } catch (error) {
        debugPrint("Error checking Health Connect status: $error");
        return null;
      }
    }
    return null;
  }

  /// Authorize and request permissions
  static Future<bool> authorize(Health health) async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPerms = await health.hasPermissions(
      types,
      permissions: permissions,
    );

    bool authorized = false;
    if (hasPerms == false || hasPerms == null) {
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

    return authorized;
  }

  /// Install Health Connect
  static Future<void> installHealthConnect(Health health) async {
    try {
      await health.installHealthConnect();
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      debugPrint("Error installing Health Connect: $error");
    }
  }
}