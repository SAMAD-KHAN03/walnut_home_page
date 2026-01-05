import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:walnut_home_page/provider/questionnaire_card_provider.dart';

class QuestionnaireSectionsOverviewScreen extends StatelessWidget {
  const QuestionnaireSectionsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = context
        .select<QuestionnaireCardsProvider, List<QuestionnaireCard>>(
          (p) => p.cards,
        );

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans', // match display font
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                children: const [
                  TextSpan(
                    text: 'Your Health\n',
                    style: TextStyle(
                      color: Color(0xFF1F2937), // text-light
                    ),
                  ),
                  TextSpan(
                    text: 'Journey',
                    style: TextStyle(
                      color: Color(0xFF7C3AED), // primary purple
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CompletionBar(progress: 0.1),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: cards[index],
                  child: const _QuestionnaireCardTile(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionnaireCardTile extends StatelessWidget {
  const _QuestionnaireCardTile();

  @override
  Widget build(BuildContext context) {
    return Selector<QuestionnaireCard, bool>(
      selector: (_, card) => card.isComplete,
      builder: (context, isComplete, _) {
        final card = context.read<QuestionnaireCard>();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(
                color: isComplete ? Colors.green : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Row(
                    children: [
                      Icon(
                        isComplete ? Icons.check_circle : Icons.close,
                        color: isComplete
                            ? Colors.green
                            : const Color(0xFFD40E00),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          card.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isComplete ? "Completed" : "Incomplete",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CompletionBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0

  const CompletionBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: label + percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Completion Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF9CA3AF) // text-muted-dark
                    : const Color(0xFF6B7280), // text-muted-light
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C3AED), // primary
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress bar background
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF374151) // gray-700
                : const Color(0xFFE5E7EB), // gray-200
            borderRadius: BorderRadius.circular(100),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED), // primary
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Helper text
        Text(
          'Just a few more steps to personalize your plan.',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
