import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:walnut_home_page/dashboard_screen.dart';

import 'package:walnut_home_page/protocol_engine/protocol_engine_dashboard.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/provider/health_provider.dart';
import 'package:walnut_home_page/provider/questionnaire_card_provider.dart';
import 'package:walnut_home_page/test_backend.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerHealthExpertProvider()),
ChangeNotifierProvider(create: (_)=>QuestionnaireCardsProvider())
      ],
      child: const MaterialApp(home: QuestionnaireSectionsOverviewScreen()),
    ),
  );
}
