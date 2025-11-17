import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/all_screen.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/provider/health_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    HealthProvider(
      health: Health()..configure(),
      child: ChangeNotifierProvider(
        create: (context) => CustomerHealthExpertProvider(),
        child: MaterialApp(home: const AmaraHealthApp()),
      ),
    ),
  );
}
