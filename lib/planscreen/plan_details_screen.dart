import 'package:flutter/material.dart';
import 'package:walnut_home_page/planscreen/models/adjustment_item.dart';
import 'package:walnut_home_page/planscreen/models/expert_team.dart';
import 'package:walnut_home_page/planscreen/models/insight_item.dart';
import 'package:walnut_home_page/planscreen/models/protocol_data.dart';
import 'package:walnut_home_page/planscreen/models/protocol_overview.dart';
import 'package:walnut_home_page/planscreen/models/timeline_day.dart';

/// Data for a single Adjustment entry

// --- 2. MOCK DATA (Simulates AI Agent's Final Output) ---
// In a real application, this data would be fetched from the network,
// parsed from the AI's JSON output, and loaded into these objects.

final Color primaryColor = const Color(0xFF00BFA5);

class PlanDetailsScreen extends StatelessWidget {
  ProtocolData mockProtocolData;
  PlanDetailsScreen({Key? key, required this.mockProtocolData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              // Header Section: Now uses protocolData
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockProtocolData.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: mockProtocolData.progress,
                      backgroundColor: Colors.grey.shade200,
                      color: primaryColor,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${mockProtocolData.phase} • ${mockProtocolData.phaseDetail}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: primaryColor,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Timeline'),
                        Tab(text: 'Adjustments'),
                        Tab(text: 'Insights'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Pass the specific data model to each tab builder
                    _buildOverviewTab(mockProtocolData.overview),
                    _buildTimelineTab(mockProtocolData.timeline),
                    _buildAdjustmentsTab(mockProtocolData.adjustments),
                    _buildInsightsTab(mockProtocolData.insights),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB BUILDER IMPLEMENTATIONS (Now Data-Driven) ---

  Widget _buildOverviewTab(ProtocolOverview overview) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Goals & Targets', overview.goals),
          const SizedBox(height: 16),
          _buildInfoCard('Current Phase Focus', overview.phaseFocus),
          const SizedBox(height: 16),
          _buildExpertTeamCard(overview.expertTeam),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(List<TimelineDay> timeline) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final day = timeline[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day.date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: day.statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      day.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: day.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${day.taskCount} tasks scheduled',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdjustmentsTab(List<AdjustmentItem> adjustments) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: adjustments.map((item) {
        return _buildAdjustmentCard(item.date, item.description, item.source);
      }).toList(),
    );
  }

  Widget _buildInsightsTab(List<InsightItem> insights) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: insights.map((item) {
          if (item.type == 'KeyInsight') {
            return _buildKeyInsightCard(item);
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGraphPlaceholder(item),
            );
          }
        }).toList(),
      ),
    );
  }

  // --- CUSTOM WIDGETS (Drawing components from data) ---

  Widget _buildExpertTeamCard(ExpertTeam team) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primaryColor,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expert Team',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${team.name} + ${team.modelVersion}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Adjust'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentCard(String date, String description, String source) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            source,
            style: TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInsightCard(InsightItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description!, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildGraphPlaceholder(InsightItem item) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 48, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
