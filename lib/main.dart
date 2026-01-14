import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:walnut_home_page/constants/constants.dart';

import 'package:walnut_home_page/provider/questionnaire_section_provider.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/provider/health_provider.dart';
import 'package:walnut_home_page/provider/questionnaire_card_provider.dart';
import 'package:walnut_home_page/questionnaire_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final String? userid = pref.getString("userId");
  if (userid == null) {
    final uuid = Uuid().v4();
    await pref.setString("userId", uuid);
    log("user not registered registering...");
  } else {
    userId = userid;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerHealthExpertProvider()),
        ChangeNotifierProvider(create: (_) => QuestionnaireCardsProvider()),
        ChangeNotifierProvider(create: (_) => QuestionnaireSectionProvider()),
      ],
      child: KeyboardDismissOnTap(
        child: const MaterialApp(home: QuestionnaireDashboard()),
      ),
    ),
  );
}

//specially for ios
class KeyboardDismissOnTap extends StatelessWidget {
  final Widget child;
  const KeyboardDismissOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // <- important for iOS
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
