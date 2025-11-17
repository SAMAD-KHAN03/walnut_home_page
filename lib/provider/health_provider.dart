import 'package:flutter/material.dart';
import 'package:health/health.dart';

/// Simple Health instance provider
class HealthProvider extends InheritedWidget {
  final Health health;

  const HealthProvider({
    Key? key,
    required this.health,
    required Widget child,
  }) : super(key: key, child: child);

  static Health of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<HealthProvider>();
    assert(provider != null, 'HealthProvider not found in widget tree');
    return provider!.health;
  }

  @override
  bool updateShouldNotify(HealthProvider oldWidget) => false;
}

/// Usage Example:
/*
// 1. Wrap your app with HealthProvider
void main() {
  runApp(
    HealthProvider(
      health: Health()..configure(),
      child: const MyApp(),
    ),
  );
}

// 2. Access Health instance in any widget
class FourDimensionUserInfoDashboard extends StatelessWidget {
  const FourDimensionUserInfoDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final health = HealthProvider.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          DailyChangeIndicatorRow(health: health),
          const LabResultsScreen(),
        ],
      ),
    );
  }
}
*/