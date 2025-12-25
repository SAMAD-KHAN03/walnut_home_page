import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _adherenceCard(cs),
              const SizedBox(height: 16),
              _streaksCard(context),
              const SizedBox(height: 16),
              _improvementsCard(context),
              const SizedBox(height: 16),
              _achievementsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ADHERENCE =================
  Widget _adherenceCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [cs.primary, cs.primaryContainer]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Adherence Rate',
            style: TextStyle(color: cs.onPrimary.withOpacity(.7)),
          ),
          const SizedBox(height: 8),
          Text(
            '87%',
            style: TextStyle(
              color: cs.onPrimary,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Tasks\nCompleted', '147', cs),
              _divider(cs),
              _stat('Current\nStreak', '12 days', cs),
              _divider(cs),
              _stat('Best\nStreak', '18 days', cs),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, ColorScheme cs) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: cs.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: cs.onPrimary.withOpacity(.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _divider(ColorScheme cs) {
    return Container(width: 1, height: 40, color: cs.onPrimary.withOpacity(.3));
  }

  // ================= STREAKS =================
  Widget _streaksCard(BuildContext context) {
    return _card(
      context,
      title: 'Best Habit Streaks',
      child: Column(
        children: const [
          _StreakItem('🌅 Morning Sunlight', 15),
          _StreakItem('💧 Hydration Goal', 12),
          _StreakItem('🧘 Stress Management', 8),
          _StreakItem('🥗 Nutrition Compliance', 18),
        ],
      ),
    );
  }

  // ================= IMPROVEMENTS =================
  Widget _improvementsCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _card(
      context,
      title: 'Health Improvements',
      child: Column(
        children: [
          _improvement(context, 'HRV', '+12%', Icons.trending_up),
          _improvement(context, 'Sleep Quality', '+14%', Icons.trending_up),
          _improvement(
            context,
            'CRP (Inflammation)',
            '-18%',
            Icons.trending_down,
          ),
          _improvement(context, 'Stress Level', '-22%', Icons.trending_down),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your inflammation dropped steadily for 3 weeks. Next focus: increase morning sunlight exposure.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _improvement(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ================= ACHIEVEMENTS =================
  Widget _achievementsCard(BuildContext context) {
    return _card(
      context,
      title: 'Achievements',
      child: Row(
        children: const [
          _Badge('🌟', '7-Day\nSleep Master', true),
          SizedBox(width: 12),
          _Badge('💪', 'Stress\nResilience L2', true),
          SizedBox(width: 12),
          _Badge('🎯', 'Perfect\nWeek', false),
        ],
      ),
    );
  }

  // ================= SHARED CARD =================
  Widget _card(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: cs.shadow.withOpacity(.08), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ================= SUB WIDGETS =================

class _StreakItem extends StatelessWidget {
  final String label;
  final int days;

  const _StreakItem(this.label, this.days);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$days days',
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String emoji;
  final String label;
  final bool unlocked;

  const _Badge(this.emoji, this.label, this.unlocked);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unlocked ? cs.primary.withOpacity(.1) : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unlocked ? cs.primary : cs.outline,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 32,
                color: unlocked ? null : cs.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: unlocked ? cs.onSurface : cs.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
