import 'package:flutter/material.dart';
import 'package:walnut_home_page/fitness_data_screen.dart';
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
    PlansScreen(),
    const FitnessDataScreen(),
    const ProgressScreen(),
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
            icon: Icon(Icons.insights),
            label: 'Progress',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
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
                              borderRadius: BorderRadius.circular(20),
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
                              HabitTimelineScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
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
                      child: Center(
                        child: Text(
                          "View Weekly Plan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

// ============= CHAT SCREEN =============
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hi Riya! I\'m Amara, your AI health coach. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'Why did you reduce my workout load today?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      text:
          'Great question! I noticed your HRV dropped to 58ms this morning (down from your 7-day average of 68ms), which indicates your body needs more recovery. Your sleep quality was also slightly lower last night at 6.2 hours. I adjusted today\'s workout from high-intensity to a light 15-minute walk to prioritize recovery.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      quickActions: ['View today\'s plan', 'See HRV trends', 'Adjust manually'],
    ),
  ];

  bool _isTyping = false;
  String _streamingText = "";

  // Simulates ChatGPT-like streaming text response
  Future<void> _simulateAIResponse(String userMessage) async {
    setState(() => _isTyping = true);

    // Add "Thinking..." placeholder message
    _messages.add(
      ChatMessage(
        text: "Thinking...",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    // Dummy AI response for now (you can later replace with real backend text stream)
    const responseText =
        "Based on your recent activity, I adjusted your plan to optimize recovery and maintain consistency. Would you like to view today’s updated plan?";

    // Replace "Thinking..." with streaming text
    _messages.removeLast();
    _streamingText = "";
    _messages.add(
      ChatMessage(text: "", isUser: false, timestamp: DateTime.now()),
    );
    setState(() {});

    // Stream text like ChatGPT
    for (int i = 0; i < responseText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      _streamingText = responseText.substring(0, i + 1);
      setState(() {
        _messages[_messages.length - 1] = ChatMessage(
          text: _streamingText,
          isUser: false,
          timestamp: DateTime.now(),
        );
      });
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
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Project Amara',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Your AI Health Coach',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
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
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TypingIndicator(),
            ),
          _buildInputArea(),
        ],
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
          IconButton(
            icon: const Icon(Icons.attach_file),
            color: const Color(0xFF00BFA5),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            color: const Color(0xFF00BFA5),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask Amara anything...',
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
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: () {
                if (_messageController.text.isNotEmpty && !_isTyping) {
                  final userMessage = _messageController.text.trim();
                  setState(() {
                    _messages.add(
                      ChatMessage(
                        text: userMessage,
                        isUser: true,
                        timestamp: DateTime.now(),
                      ),
                    );
                    _messageController.clear();
                  });
                  _simulateAIResponse(userMessage);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============= TYPING INDICATOR (3 dots) =============
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return FadeTransition(
          opacity: Tween(begin: 0.2, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(i * 0.2, 1.0, curve: Curves.easeInOut),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(radius: 3, backgroundColor: Colors.teal),
          ),
        );
      }),
    );
  }
}

// ============= CHAT MESSAGE MODEL =============
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? quickActions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickActions,
  });
}

// ============= CHAT BUBBLE WIDGET =============
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF00BFA5) : Colors.white,
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
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            if (message.quickActions != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: message.quickActions!
                    .map(
                      (action) => OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00BFA5)),
                          foregroundColor: const Color(0xFF00BFA5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          action,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
