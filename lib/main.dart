import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/all_screen.dart';
import 'package:walnut_home_page/health_analytics_detailed_screens/medical_report_detailed_screen.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/provider/health_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerHealthExpertProvider()),
      ],
      child: const MaterialApp(home: AmaraHealthApp()),
    ),
  );
}
