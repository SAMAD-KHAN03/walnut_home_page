import 'package:flutter/material.dart';

import 'package:walnut_home_page/data/weekly_tasks_dummy_data.dart';

import 'package:walnut_home_page/models/weekly_tasks_info.dart';
import 'package:walnut_home_page/protocol_engine/protocol_progress_screen.dart';
import 'package:walnut_home_page/theme/themes.dart';

class ProtocolWeeklyRoadmapScreen extends StatelessWidget {
  const ProtocolWeeklyRoadmapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Plan Overview',
      debugShowCheckedModeBanner: false,
      theme: lighttheme,
      darkTheme: darktheme,
      home: const WeeklyPlanScaffold(),
    );
  }
}

class WeeklyPlanScaffold extends StatelessWidget {
  const WeeklyPlanScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(body: const WeeklyPlanScreen());
  }
}

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  late WeeklyPlan weeklyPlan;

  @override
  void initState() {
    super.initState();
    weeklyPlan = getDummyWeeklyPlan();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: isDark
                    ? const Color(0xFF102222).withOpacity(0.95)
                    : const Color(0xFFF6F8F8).withOpacity(0.95),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {},
                ),
                title: Column(
                  children: [
                    Text(
                      'Week ${weeklyPlan.weekNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weeklyPlan.dateRange,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AI Badge
                      if (weeklyPlan.isAIGenerated) ...[
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF11D4D4).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF11D4D4).withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF11D4D4),
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'AI GENERATED PLAN',
                                  style: TextStyle(
                                    color: Color(0xFF11D4D4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Theme Card
                      _buildThemeCard(weeklyPlan.theme, isDark),
                      const SizedBox(height: 24),

                      // Weekly Targets
                      _buildWeeklyTargets(weeklyPlan.targets, isDark),
                      const SizedBox(height: 24),

                      // Focus Areas
                      _buildFocusAreas(weeklyPlan.focusAreas, isDark),
                      const SizedBox(height: 24),

                      // Weekly Goals
                      _buildWeeklyGoals(weeklyPlan.goals, isDark),
                      const SizedBox(height: 24),

                      // Success Vision
                      _buildSuccessVision(weeklyPlan.successVision, isDark),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.transparent,
                          const Color(0xFF102222).withOpacity(0.95),
                          const Color(0xFF102222),
                        ]
                      : [
                          Colors.transparent,
                          const Color(0xFFF6F8F8).withOpacity(0.95),
                          const Color(0xFFF6F8F8),
                        ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProgressScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11D4D4),
                  foregroundColor: const Color(0xFF111818),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF11D4D4).withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.assignment, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'View Protocol\'s Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(WeekTheme theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background icon
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                theme.icon,
                size: 120,
                color: const Color(0xFF11D4D4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THEME OF THE WEEK',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  theme.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF11D4D4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        theme.basedOn,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTargets(List<WeeklyTarget> targets, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Targets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Edit targets action
              //   },
              //   child: const Text(
              //     'Edit targets',
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Color(0xFF11D4D4),
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: targets.asMap().entries.map((entry) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: entry.key > 0 ? 6 : 0,
                  right: entry.key < targets.length - 1 ? 6 : 0,
                ),
                child: _buildMetricCard(entry.value, isDark),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricCard(WeeklyTarget target, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(target.icon, color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  target.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                target.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                target.unit,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: target.progress,
              minHeight: 4,
              backgroundColor: isDark
                  ? Colors.grey.shade700
                  : Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF11D4D4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusAreas(List<FocusArea> areas, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Focus Areas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: areas.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildFocusCard(areas[index], isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFocusCard(FocusArea area, bool isDark) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: area.isHighlighted
              ? const Color(0xFF11D4D4).withOpacity(0.3)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        ),
        boxShadow: area.isHighlighted
            ? [
                BoxShadow(
                  color: const Color(0xFF11D4D4).withOpacity(0.2),
                  blurRadius: 8,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          if (area.isHighlighted)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF11D4D4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: area.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(area.icon, color: area.color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                area.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                area.subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoals(List<WeeklyGoal> goals, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Goals',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...goals.asMap().entries.map((entry) {
            final index = entry.key;
            final goal = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                if (index > 0)
                  Container(
                    height: 1,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                if (index > 0) const SizedBox(height: 16),
                _buildGoalItem(goal, isDark),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGoalItem(WeeklyGoal goal, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   width: 20,
        //   height: 20,
        //   child: Checkbox(
        //     value: goal.isCompleted,
        //     onChanged: (val) {
        //       setState(() {
        //         goal.isCompleted = val ?? false;
        //       });
        //     },
        //     activeColor: const Color(0xFF11D4D4),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(4),
        //     ),
        //   ),
        // ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: goal.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: goal.isCompleted
                      ? Colors.grey.shade400
                      : (isDark ? Colors.white : const Color(0xFF111818)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                goal.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessVision(SuccessVision vision, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF11D4D4).withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF11D4D4).withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(vision.icon, color: const Color(0xFF11D4D4), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vision.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vision.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
