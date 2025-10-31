import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HabitTimelineScreen extends StatefulWidget {
  const HabitTimelineScreen({super.key});

  @override
  State<HabitTimelineScreen> createState() => _HabitTimelineScreenState();
}

class _HabitTimelineScreenState extends State<HabitTimelineScreen> {
  // Sample data: completed days
  int completedDays = 3;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  void _showDayDetails(String day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pull handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Header section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Oct 2025",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Focus: Recovery & Balance 🌿",
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                  const SizedBox(height: 24),

                  // Mood check-in
                  const Text(
                    "How are you feeling today?",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("😊", style: TextStyle(fontSize: 30)),
                      Text("😐", style: TextStyle(fontSize: 30)),
                      Text("😔", style: TextStyle(fontSize: 30)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Tasks section
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskItem("🌞 Morning Meditation (10 min)"),
                  _buildTaskItem("🥗 Anti-inflammatory Breakfast"),
                  _buildTaskItem("🚶‍♂️ Evening Walk (20 min)"),
                  _buildTaskItem("📝 Journal 3 things you're grateful for"),
                  const SizedBox(height: 28),

                  // Insights
                  const Text(
                    "AI Insight ✨",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Your HRV improved 8% since last week. Keep hydration consistent and get 7–8h sleep.",
                      style: TextStyle(height: 1.5, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Close button
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Done for Today",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper widget for each task
  Widget _buildTaskItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = completedDays / days.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Weekly Habit Timeline"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            const Text(
              "Your Weekly Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // Timeline line + nodes
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base Line
                  // Container(
                  //   height: 4,
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(horizontal: 8),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[300],
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  // ),
                  // Animated progress line
                  // FractionallySizedBox(
                  //   alignment: Alignment.centerLeft,
                  //   widthFactor: progress,
                  //   child: Container(
                  //     height: 4,
                  //     decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //         colors: [Colors.teal, Colors.greenAccent],
                  //       ),
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //   ),
                  // ),
                  // Circular nodes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(days.length, (index) {
                      bool isCompleted = index < completedDays;
                      return GestureDetector(
                        onTap: () => _showDayDetails(days[index]),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isCompleted ? Colors.teal : Colors.white,
                                border: Border.all(
                                  color: isCompleted
                                      ? Colors.teal
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: isCompleted
                                    ? [
                                        BoxShadow(
                                          color: Colors.teal.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              days[index],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Summary / Call to action
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "You’ve completed $completedDays of 7 days 🎯",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 200,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.teal, Colors.greenAccent],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        completedDays = (completedDays + 1).clamp(
                          0,
                          days.length,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Mark Next Day Complete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
