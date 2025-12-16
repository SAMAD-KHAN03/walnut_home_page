import 'package:flutter/material.dart';
import 'package:walnut_home_page/data/chat_message_dummy_data.dart';
import 'package:walnut_home_page/health_analytics_detailed_screens/fitness_data_screen.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';
import 'package:walnut_home_page/health_analytics_dashboard/four_dimension_user_info_dashboard.dart';
import 'package:walnut_home_page/planscreen/plans_screen.dart';
import 'package:walnut_home_page/weeklyplanscreens/weekly_plan.dart';

class AmaraHealthApp extends StatelessWidget {
  const AmaraHealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Amara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeDashboard(),
    );
  }
}

// ============= HOME DASHBOARD =============
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PlansScreen(),
    const FourDimensionUserInfoDashboard(),
    const ProgressScreen(),
    const HealthExpert_Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00BFA5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'HealtStats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Health Experts',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                title: "Project Amara",
                subtitle: "Your AI Health Coach",
                leadingIcon: Icons.psychology,
                initialMessages: initialMessages,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
}

// ============= DASHBOARD SCREEN =============
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00BFA5),
                  const Color(0xFF00BFA5).withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Good Morning, Riya 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Monday, October 27, 2025',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF00BFA5)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('🌿', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Recovery Score',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '83%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF00BFA5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('View Plan'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Key Metrics Carousel
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Key Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            // HabitTimelineScreen(),
                            WeeklyMonthlyTaskScreen(),
                      ),
                    );
                  },
                  child: Container(
                    // width: 10,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00BFA5),
                          const Color(0xFF00BFA5).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "See Timeline",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                MetricCard(
                  icon: Icons.bedtime,
                  title: 'Sleep',
                  value: '7.5h',
                  subtitle: 'HRV: 68ms',
                  color: Color(0xFF5E35B1),
                ),
                MetricCard(
                  icon: Icons.directions_run,
                  title: 'Activity',
                  value: '8,432',
                  subtitle: 'steps today',
                  color: Color(0xFFFF6B6B),
                ),
                MetricCard(
                  icon: Icons.psychology,
                  title: 'Mood',
                  value: '😊 Good',
                  subtitle: 'Stress: Low',
                  color: Color(0xFFFFB347),
                ),
                MetricCard(
                  icon: Icons.restaurant,
                  title: 'Nutrition',
                  value: '1,450',
                  subtitle: 'calories',
                  color: Color(0xFF4ECDC4),
                ),
              ],
            ),
          ),

          // Today's Tasks
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Today\'s Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  '3 of 7 completed',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const TaskCard(
            icon: Icons.wb_sunny,
            title: 'Morning Sunlight',
            subtitle: '5 mins outside before 9AM',
            timeWindow: '7:00 - 9:00 AM',
            completed: true,
          ),
          const TaskCard(
            icon: Icons.restaurant_menu,
            title: 'High-protein breakfast',
            subtitle: 'Include eggs or Greek yogurt',
            timeWindow: '8:00 - 10:00 AM',
            completed: true,
          ),
          const TaskCard(
            icon: Icons.local_drink,
            title: 'Hydration Check',
            subtitle: 'Drink 500ml water',
            timeWindow: '10:00 AM',
            completed: false,
          ),
          const TaskCard(
            icon: Icons.fitness_center,
            title: 'Light Movement',
            subtitle: '15-min walk or yoga',
            timeWindow: '12:00 - 2:00 PM',
            completed: false,
          ),
          const TaskCard(
            icon: Icons.medication,
            title: 'Magnesium glycinate',
            subtitle: '200mg after dinner',
            timeWindow: '8:00 - 9:00 PM',
            completed: false,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ============= METRIC CARD WIDGET =============
class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const MetricCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============= TASK CARD WIDGET =============
class TaskCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timeWindow;
  final bool completed;

  const TaskCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeWindow,
    required this.completed,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool _completed;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _completed = widget.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _completed ? const Color(0xFF00BFA5) : Colors.grey.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _completed
                          ? const Color(0xFF00BFA5).withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: _completed ? const Color(0xFF00BFA5) : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: _completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: _completed ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.timeWindow,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00BFA5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_completed)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          color: const Color(0xFF00BFA5),
                          onPressed: () => setState(() => _completed = true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.grey,
                          onPressed: () {},
                        ),
                      ],
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF00BFA5),
                      size: 28,
                    ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Why this matters:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Morning sunlight exposure helps regulate your circadian rhythm and boosts cortisol at the right time, improving energy and sleep quality.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ============= PROGRESS SCREEN =============
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildAdherenceCard(),
              const SizedBox(height: 16),
              _buildStreaksCard(),
              const SizedBox(height: 16),
              _buildImprovementsCard(),
              const SizedBox(height: 16),
              _buildAchievementsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdherenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Adherence Rate',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '87%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Tasks\nCompleted', '147'),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildStatItem('Current\nStreak', '12 days'),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildStatItem('Best\nStreak', '18 days'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStreaksCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Habit Streaks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStreakItem('🌅 Morning Sunlight', 15, 'days'),
          _buildStreakItem('💧 Hydration Goal', 12, 'days'),
          _buildStreakItem('🧘 Stress Management', 8, 'days'),
          _buildStreakItem('🥗 Nutrition Compliance', 18, 'days'),
        ],
      ),
    );
  }

  Widget _buildStreakItem(String label, int days, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$days $unit',
              style: const TextStyle(
                color: Color(0xFF00BFA5),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Improvements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildImprovementItem('HRV', '+12%', Colors.green, Icons.trending_up),
          _buildImprovementItem(
            'Sleep Quality',
            '+14%',
            Colors.green,
            Icons.trending_up,
          ),
          _buildImprovementItem(
            'CRP (Inflammation)',
            '-18%',
            Colors.green,
            Icons.trending_down,
          ),
          _buildImprovementItem(
            'Stress Level',
            '-22%',
            Colors.green,
            Icons.trending_down,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF00BFA5),
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your inflammation dropped steadily for 3 weeks. Next focus: increase morning sunlight exposure.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF2C3E50)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBadge('🌟', '7-Day\nSleep Master', true),
              const SizedBox(width: 12),
              _buildBadge('💪', 'Stress\nResilience L2', true),
              const SizedBox(width: 12),
              _buildBadge('🎯', 'Perfect\nWeek', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String emoji, String label, bool unlocked) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unlocked
              ? const Color(0xFF00BFA5).withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unlocked ? const Color(0xFF00BFA5) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 32,
                color: unlocked ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: unlocked ? const Color(0xFF2C3E50) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== MESSAGE MODEL (UPDATED) =====================
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? responseOptions; // Options for a responsive AI message
  final String type; // 'plain' or 'responsive'
  bool optionsActive; // To track if options have been picked

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.responseOptions,
    this.type = 'plain',
    this.optionsActive = true,
  });

  // Helper method to create a copy for state updates
  ChatMessage copyWith({
    String? text,
    List<String>? responseOptions,
    bool? optionsActive,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      responseOptions: responseOptions ?? this.responseOptions,
      type: type,
      optionsActive: optionsActive ?? this.optionsActive,
    );
  }
}

// ===================== CHAT BUBBLE (FIXED) =====================
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onOptionSelected;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (Avatar and Message Bubble code remains the same) ...

    // Logic to simulate the avatar based on screenshot (simple colored circle)
    Widget auraAvatar = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          // Placeholder for the actual avatar image
          image: NetworkImage(
            "https://picsum.photos/36?random=${message.timestamp.millisecondsSinceEpoch}",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[auraAvatar, const SizedBox(width: 8)],

          Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Avatar Name/Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  message.isUser ? "You" : "Amara",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),

              // Message Bubble
              Container(
                constraints: BoxConstraints(
                  // The constraints here are already correct (max 75% of screen width)
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? const Color(0xFF00BFA5)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SelectableText(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black87,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),

              // --- RESPONSIVE OPTIONS (FIX APPLIED HERE) ---
              if (!message.isUser &&
                  message.type == 'responsive' &&
                  message.responseOptions != null &&
                  message.optionsActive) ...[
                const SizedBox(height: 12),

                // FIX: Wrap the Row in a SingleChildScrollView for horizontal scrolling
                SizedBox(
                  // Constrain the width of the SingleChildScrollView to the bubble's width
                  width:
                      MediaQuery.of(context).size.width * 0.75 -
                      44, // 0.75 width minus avatar/padding/spacing
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: message.responseOptions!
                          .map(
                            (action) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                onPressed: () => onOptionSelected(action),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      action.toLowerCase().contains("yes") ||
                                          action.toLowerCase().contains("start")
                                      ? const Color(0xFF00BFA5)
                                      : Colors.white,
                                  foregroundColor:
                                      action.toLowerCase().contains("yes") ||
                                          action.toLowerCase().contains("start")
                                      ? Colors.white
                                      : Colors.black87,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color:
                                          action.toLowerCase().contains(
                                                "yes",
                                              ) ||
                                              action.toLowerCase().contains(
                                                "start",
                                              )
                                          ? const Color(0xFF00BFA5)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  action,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== CHAT SCREEN (REVISED) =====================
class ChatScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData? leadingIcon;
  final List<ChatMessage> initialMessages;

  const ChatScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    this.leadingIcon = Icons.psychology,
    this.initialMessages = const [],
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  bool _isTyping = false;
  String _streamingText = "";
  int _aiResponseCount = 0; // To alternate response types

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleOptionSelected(int messageIndex, String selectedOption) {
    if (_isTyping) return;

    // 1. Deactivate options for the AI message
    setState(() {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        optionsActive: false,
      );
    });

    // 2. Simulate user sending the selected option as a new message
    _sendMessage(selectedOption, simulateResponse: true);
  }

  Future<void> _sendMessage(
    String text, {
    bool simulateResponse = false,
  }) async {
    final userMessage = text.trim();
    if (userMessage.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _messageController.clear();
      _scrollToBottom();
    });

    if (simulateResponse) {
      await _simulateAIResponse(userMessage);
    }
  }

  Future<void> _simulateAIResponse(String userMessage) async {
    _aiResponseCount++;
    setState(() => _isTyping = true);

    // Add Thinking message
    _messages.add(
      ChatMessage(text: "...", isUser: false, timestamp: DateTime.now()),
    );
    _scrollToBottom();
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));
    _messages.removeLast(); // Remove "..."

    // Example logic: Alternate between responsive and plain
    bool isResponsive = _aiResponseCount % 2 == 1;

    String responseText;
    List<String>? options;

    if (isResponsive) {
      responseText =
          "I see. To help you manage your weight, should we focus on a 'Nutrition Plan' or a 'Workout Schedule' first?";
      options = ["Nutrition Plan", "Workout Schedule"];
    } else {
      responseText =
          "Got it. I'll search for the best fitness coaches in your area specializing in weight reduction. I recommend Dr. Neel Rajan and his team.";
      options = null;
    }

    _streamingText = "";
    _messages.add(
      ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
        type: isResponsive ? 'responsive' : 'plain',
        responseOptions: options,
        optionsActive: true,
      ),
    );
    setState(() {});

    for (int i = 0; i < responseText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      _streamingText = responseText.substring(0, i + 1);
      setState(() {
        _messages[_messages.length - 1] = _messages[_messages.length - 1]
            .copyWith(text: _streamingText);
      });
      _scrollToBottom();
    }

    setState(() => _isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                widget.leadingIcon ?? Icons.chat,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => ChatBubble(
                message: _messages[index],
                onOptionSelected: (option) =>
                    _handleOptionSelected(index, option),
              ),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TypingIndicator(),
            ),
          _buildAdditionalFeatures(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description, size: 20),
            label: const Text("Get Daily Summary"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.sentiment_satisfied_alt, "Log Mood"),
                _buildActionButton(Icons.notifications_none, "Set Reminder"),
                _buildActionButton(Icons.share, "Share Progress"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          textStyle: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.grey.shade600,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Chat with Amara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_upward),
              color: Colors.white,
              onPressed: () =>
                  _sendMessage(_messageController.text, simulateResponse: true),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== TYPING INDICATOR =====================
// (No changes needed, kept for completeness)
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 60.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(radius: 3, backgroundColor: Colors.teal),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(radius: 3, backgroundColor: Colors.teal),
          ),
          CircleAvatar(radius: 3, backgroundColor: Colors.teal),
        ],
      ),
    );
  }
}
// // ============= CHAT BUBBLE WIDGET =============
// class ChatBubble extends StatelessWidget {
//   final ChatMessage message;

//   const ChatBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         child: Column(
//           crossAxisAlignment: message.isUser
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: message.isUser ? const Color(0xFF00BFA5) : Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(20),
//                   topRight: const Radius.circular(20),
//                   bottomLeft: Radius.circular(message.isUser ? 20 : 4),
//                   bottomRight: Radius.circular(message.isUser ? 4 : 20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: SelectableText(
//                 message.text,
//                 style: TextStyle(
//                   color: message.isUser ? Colors.white : Colors.black87,
//                   fontSize: 14,
//                   height: 1.4,
//                 ),
//               ),
//             ),
//             if (message.quickActions != null) ...[
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 children: message.quickActions!
//                     .map(
//                       (action) => OutlinedButton(
//                         onPressed: () {},
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFF00BFA5)),
//                           foregroundColor: const Color(0xFF00BFA5),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: Text(
//                           action,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
