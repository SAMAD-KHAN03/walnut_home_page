import 'package:flutter/material.dart';
import 'package:walnut_home_page/amara_ai/chat_screen.dart';

import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';

// Import your ChatScreen file here
// import 'chat_screen.dart';

class CustomerHealthExpertDetails extends StatefulWidget {
  final HealthExpert expert;

  const CustomerHealthExpertDetails({Key? key,required this.expert}) : super(key: key);

  @override
  State<CustomerHealthExpertDetails> createState() =>
      _CustomerHealthExpertDetails();
}

class _CustomerHealthExpertDetails extends State<CustomerHealthExpertDetails>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final tabs = const [
    Tab(text: "Chat"),
    Tab(text: "Announcements"),
    Tab(text: "Reports"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAnnouncementsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No announcements yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "No reports available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            indicatorWeight: 3,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatScreen(
              title: widget.expert.name,
              subtitle: widget.expert.type,
              leadingIcon: Icons.local_hospital,
              initialMessages: [
                ChatMessage(
                  text:
                      "Hello! I’m Dr. Meera Patel. How are you feeling today?",
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              ],
            ), // Reuses your AI Chat screen exactly as-is
            // Announcement tab
            Center(child: Text("No announcements yet")),
            // Reports tab
            Center(child: Text("No reports yet")),
          ],
        ),
      ),
    );
  }
}
