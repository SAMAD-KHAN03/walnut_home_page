import 'package:flutter/material.dart';
import 'package:walnut_home_page/data/daily_tasks_dummy_data.dart';
import 'package:walnut_home_page/models/daily_task.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({Key? key}) : super(key: key);

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  final List<DailyTasks> tasks = dailytasks;

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
                elevation: 1,
                toolbarHeight: 72,
                backgroundColor: isDark
                    ? const Color(0xFF102219).withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF102219).withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.menu),
                                //   onPressed: () {},
                                //   padding: const EdgeInsets.all(8),
                                //   constraints: const BoxConstraints(),
                                // ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Wed, Oct 24',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '75%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Daily Goal',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: 0.75,
                                      strokeWidth: 3,
                                      backgroundColor: isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade200,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Color(0xFF13EC80),
                                          ),
                                    ),
                                    const Icon(
                                      Icons.bolt,
                                      color: Color(0xFF13EC80),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Daily Focus Card
                      _buildDailyFocusCard(),
                      const SizedBox(height: 24),

                      // Morning Section
                      _buildSectionHeader(
                        'Morning',

                        Icons.wb_sunny,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      ...tasks
                          .where((t) => t.section == TaskSection.morning)
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildTaskCard(task, isDark),
                            ),
                          ),

                      const SizedBox(height: 16),

                      // Nutrition Section
                      _buildSectionHeader(
                        'Nutrition',

                        Icons.restaurant,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      ...tasks
                          .where((t) => t.section == TaskSection.nutrition)
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildTaskCard(task, isDark),
                            ),
                          ),

                      const SizedBox(height: 16),

                      // Movement Section
                      _buildSectionHeader(
                        'Movement',

                        Icons.directions_run,
                        Colors.red,
                      ),
                      const SizedBox(height: 12),
                      ...tasks
                          .where((t) => t.section == TaskSection.movement)
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildTaskCard(task, isDark),
                            ),
                          ),

                      const SizedBox(height: 16),

                      // Evening Section
                      _buildSectionHeader(
                        'Evening',

                        Icons.bedtime,
                        Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      ...tasks
                          .where((t) => t.section == TaskSection.evening)
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildTaskCard(task, isDark),
                            ),
                          ),

                      // const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyFocusCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDz87TrK7FZ5308z42lL4QQkOSOtrVsgvADyO8lIdwT8u7endAklnguGxlEZVFSBsj1jYweueJSQ7pdNbxM-Y7Cy-6BlgzruSi-h76VceyPivN1_8w1R2YLv0xbGaxZcfShln3iLn9zKX7Yc2jGlLkwA7dZZw67CNNACybiz9_eMZ0IM9qhx3T4sf0RqwCIRC9wZZ6QkeyPBFpUNwvEropISb_ZPEhoBwP4-z3h2dLccpUZml1H0IzeAgLFwO3GDpmO-6Vk95Q6HpeV',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF13EC80).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF13EC80).withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.auto_awesome, color: Color(0xFF13EC80), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'AI Insight',
                    style: TextStyle(
                      color: Color(0xFF13EC80),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Metabolic Flexibility',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Focus on extending your fasting window to 16 hours today to optimize mitochondrial function.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(DailyTasks task, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2E26) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted
              ? Colors.transparent
              : (task.hasActions
                    ? const Color(0xFF13EC80).withOpacity(0.5)
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade100)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Active task left accent
          if (task.hasActions && !task.isCompleted)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF13EC80),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.only(
              left: task.hasActions ? 20 : 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: (val) {
                            setState(() {
                              task.isCompleted = val ?? false;
                            });
                          },
                          activeColor: const Color(0xFF13EC80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: task.hasActions
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.more_horiz,
                                  color: task.isCompleted
                                      ? const Color(0xFF13EC80)
                                      : Colors.grey.shade400,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          // Duration and category
                          if (task.duration != null ||
                              task.category != null) ...[
                            const SizedBox(height: 6),
                            if (task.icon != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      task.iconColor?.withOpacity(0.1) ??
                                      Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      task.icon,
                                      size: 14,
                                      color: task.iconColor ?? Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.duration ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: task.iconColor ?? Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Wrap(
                                spacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (task.duration != null)
                                    Text(
                                      task.duration!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  if (task.duration != null &&
                                      task.category != null)
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  if (task.category != null)
                                    Text(
                                      task.category!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                ],
                              ),
                          ],

                          // Description
                          if (task.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],

                          // Tags
                          if (task.tags != null && task.tags!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: task.tags!
                                  .map(
                                    (tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],

                          // Action buttons
                          if (task.hasActions && !task.isCompleted) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.close, size: 16),
                                    label: const Text('Skipped'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.grey.shade600,
                                      side: BorderSide.none,
                                      backgroundColor: isDark
                                          ? Colors.grey.shade700.withOpacity(
                                              0.5,
                                            )
                                          : Colors.grey.shade50,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.warning, size: 16),
                                    label: const Text('Had Difficulty'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.grey.shade600,
                                      side: BorderSide.none,
                                      backgroundColor: isDark
                                          ? Colors.grey.shade700.withOpacity(
                                              0.5,
                                            )
                                          : Colors.grey.shade50,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
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
}
