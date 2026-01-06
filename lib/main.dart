import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:walnut_home_page/provider/questionnaire_section_provider.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/provider/health_provider.dart';
import 'package:walnut_home_page/provider/questionnaire_card_provider.dart';
import 'package:walnut_home_page/questionnaire_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerHealthExpertProvider()),
        ChangeNotifierProvider(create: (_) => QuestionnaireCardsProvider()),
        ChangeNotifierProvider(
          create: (_) => QuestionnaireSectionProvider(
         
          ),
        ),
      ],
      child: KeyboardDismissOnTap(
        child: const MaterialApp(
          home: QuestionnaireDashboard(),
        ),
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