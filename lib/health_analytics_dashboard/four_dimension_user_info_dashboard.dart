import 'package:flutter/material.dart';
import 'package:walnut_home_page/health_analytics_dashboard/health_report_analysis_card.dart';
import 'package:walnut_home_page/health_analytics_dashboard/lifestyle_ui.dart';
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
        title: const Text('Health Analytics Dashboard'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ← Changed from Column to SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // ← Added this
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                child: Divider(thickness: 2, color: Colors.black),
              ),
              const LabResultsScreen(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                child: Divider(thickness: 1),
              ),
              const WearablesDailyChangeIndicatorCards(),
              const SizedBox(height: 20),
              // const Padding(
              //   padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
              //   child: Divider(thickness: 1),
              // ),
              // ShowLifeStyleUI(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
