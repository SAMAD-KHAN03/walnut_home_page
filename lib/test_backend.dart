import 'package:flutter/material.dart';
import 'package:walnut_home_page/models/questionnaire.dart';
import 'package:walnut_home_page/questionnaire_section_screen.dart';

class QuestionnaireSectionsOverviewScreen extends StatelessWidget {
  const QuestionnaireSectionsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Skip",
              style: TextStyle(color: const Color.fromARGB(255, 161, 146, 10)),
            ),
          ),
        ],
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Health Questionnaire'),
        // backgroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: QuestionnaireSection.values.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white24, height: 1),
        itemBuilder: (context, index) {
          final section = QuestionnaireSection.values[index];

          return SectionTile(
            title: section.title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuestionnaireSectionScreen(
                    sectionKey: section.sectionKey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        // color: const Color(0xFF1E1E1E),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
