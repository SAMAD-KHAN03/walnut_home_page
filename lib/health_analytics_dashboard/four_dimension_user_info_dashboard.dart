import 'package:flutter/material.dart';
import 'package:walnut_home_page/health_analytics_dashboard/health_report_analysis_card.dart';
import 'package:walnut_home_page/health_analytics_dashboard/wearables_daily_change_indicator_cards.dart';

class FourDimensionUserInfoDashboard extends StatefulWidget {
  const FourDimensionUserInfoDashboard({super.key});

  @override
  State<FourDimensionUserInfoDashboard> createState() =>
      _FourDimensionUserInfoDashboardState();
}

class _FourDimensionUserInfoDashboardState
    extends State<FourDimensionUserInfoDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Analytics Dash Baord'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
              child: Divider(thickness: 2, color: Colors.black),
            ),
            const LabResultsScreen(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
              child: Divider(thickness: 1, color: Colors.black),
            ),
            WearablesDailyChangeIndicatorCards(),
          ],
        ),
      ),
    );
  }
}
