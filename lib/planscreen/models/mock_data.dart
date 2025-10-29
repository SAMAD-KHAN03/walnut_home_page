import 'package:flutter/material.dart';
import 'package:walnut_home_page/planscreen/models/adjustment_item.dart';
import 'package:walnut_home_page/planscreen/models/expert_team.dart';
import 'package:walnut_home_page/planscreen/models/insight_item.dart';
import 'package:walnut_home_page/planscreen/models/protocol_data.dart';
import 'package:walnut_home_page/planscreen/models/protocol_overview.dart';
import 'package:walnut_home_page/planscreen/models/timeline_day.dart';

final mockdataArray = [
  ProtocolData(
    title: 'Thyroid Reset Protocol',
    progress: 0.35,
    phase: 'Week 3 of 8',
    phaseDetail: 'Detox Phase',

    overview: ProtocolOverview(
      goals: [
        'TSH < 2.5 mIU/L',
        'HRV +15% increase',
        'CRP < 1.0 mg/L',
        'Energy levels improvement',
      ],
      phaseFocus: [
        'Focus on liver support',
        'Eliminate inflammatory foods',
        'Optimize sleep quality',
        'Stress reduction practices',
      ],
      expertTeam: ExpertTeam(
        name: 'Dr. Arjun Verma',
        modelVersion: 'AI Model v2',
      ),
    ),

    timeline: List.generate(7, (index) {
      final bool isComplete = index < 2;
      return TimelineDay(
        date: 'Day ${index + 15} • Oct ${27 + index}',
        status: isComplete ? '✓ Complete' : 'Upcoming',
        taskCount: 7 - index,
        statusColor: isComplete ? Colors.green : Colors.grey,
        statusBgColor: isComplete
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
      );
    }),

    adjustments: [
      AdjustmentItem(
        date: '⏱ October 22',
        description: 'Reduced intensity due to low HRV',
        source: 'Amara Auto-Adjust',
      ),
      AdjustmentItem(
        date: '🥗 October 20',
        description: 'Added selenium-rich foods for thyroid support',
        source: 'Expert Recommendation',
      ),
      AdjustmentItem(
        date: '💊 October 18',
        description: 'Increased magnesium dosage to 300mg',
        source: 'Based on sleep data',
      ),
    ],

    insights: [
      InsightItem(
        type: 'KeyInsight',
        title: '📊 Key Insight',
        description:
            'Your liver enzymes improved by 18% in 3 weeks. Keep magnesium dose consistent.',
        icon: Icons.lightbulb_outline,
      ),
      InsightItem(
        type: 'Graph',
        title: 'HRV Trend',
        description: null,
        icon: Icons.show_chart,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Sleep Quality',
        description: null,
        icon: Icons.bed_outlined,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Inflammation (CRP)',
        description: null,
        icon: Icons.warning_amber_outlined,
      ),
    ],
  ),
  ProtocolData(
    title: 'Gut Rebalance Protocol',
    progress: 0.55,
    phase: 'Week 5 of 8',
    phaseDetail: 'Microbiome Restoration Phase',

    overview: ProtocolOverview(
      goals: [
        'Bloating reduction by 70%',
        'Increase in beneficial gut flora (+20%)',
        'Improved digestion and nutrient absorption',
        'Regular bowel movements (1–2/day)',
      ],
      phaseFocus: [
        'Add prebiotic & probiotic foods',
        'Eliminate refined sugar',
        'Hydration & electrolytes balance',
        'Gentle core movement routines',
      ],
      expertTeam: ExpertTeam(
        name: 'Dr. Meera Khanna',
        modelVersion: 'AI Model v3',
      ),
    ),

    timeline: List.generate(7, (index) {
      final bool isComplete = index < 4;
      return TimelineDay(
        date: 'Day ${index + 29} • Nov ${3 + index}',
        status: isComplete ? '✓ Complete' : 'Upcoming',
        taskCount: 6 - index,
        statusColor: isComplete ? Colors.green : Colors.grey,
        statusBgColor: isComplete
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
      );
    }),

    adjustments: [
      AdjustmentItem(
        date: '🌿 November 2',
        description: 'Reduced probiotic capsule to every alternate day',
        source: 'Auto Adjustment',
      ),
      AdjustmentItem(
        date: '🥬 October 31',
        description: 'Added fermented vegetables to lunch',
        source: 'Expert Suggestion',
      ),
      AdjustmentItem(
        date: '💧 October 29',
        description: 'Increased hydration goal to 3L/day',
        source: 'Based on stool consistency data',
      ),
    ],

    insights: [
      InsightItem(
        type: 'KeyInsight',
        title: '📊 Key Insight',
        description:
            'Gut microbiome diversity improved by 22%. Keep fiber intake steady.',
        icon: Icons.lightbulb_outline,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Digestive Comfort Score',
        description: null,
        icon: Icons.favorite_outline,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Microbiome Diversity',
        description: null,
        icon: Icons.eco_outlined,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Inflammation Markers',
        description: null,
        icon: Icons.warning_amber_outlined,
      ),
    ],
  ),

  ProtocolData(
    title: 'Metabolic Reset Protocol',
    progress: 0.25,
    phase: 'Week 2 of 8',
    phaseDetail: 'Insulin Sensitivity Phase',

    overview: ProtocolOverview(
      goals: [
        'Fasting glucose < 95 mg/dL',
        'Waist-to-hip ratio improvement',
        'Resting HR < 70 bpm',
        'Daily energy stability',
      ],
      phaseFocus: [
        'Intermittent fasting window (16:8)',
        'Stabilize blood sugar with balanced meals',
        'Light cardio 20 min/day',
        'Prioritize early bedtime',
      ],
      expertTeam: ExpertTeam(
        name: 'Dr. Neel Shah',
        modelVersion: 'AI Model v2.5',
      ),
    ),

    timeline: List.generate(7, (index) {
      final bool isComplete = index < 1;
      return TimelineDay(
        date: 'Day ${index + 8} • Oct ${30 + index}',
        status: isComplete ? '✓ Complete' : 'Upcoming',
        taskCount: 8 - index,
        statusColor: isComplete ? Colors.green : Colors.grey,
        statusBgColor: isComplete
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
      );
    }),

    adjustments: [
      AdjustmentItem(
        date: '🏃 October 29',
        description: 'Increased walking goal to 6k steps/day',
        source: 'Auto-Adjust',
      ),
      AdjustmentItem(
        date: '🍳 October 28',
        description: 'Added protein smoothie post-workout',
        source: 'Expert Recommendation',
      ),
      AdjustmentItem(
        date: '💤 October 27',
        description: 'Shifted sleep goal to 10:30 PM bedtime',
        source: 'Based on recovery data',
      ),
    ],

    insights: [
      InsightItem(
        type: 'KeyInsight',
        title: '📊 Key Insight',
        description:
            'Your fasting glucose dropped by 9% this week — steady progress.',
        icon: Icons.lightbulb_outline,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Blood Glucose Trend',
        description: null,
        icon: Icons.monitor_heart_outlined,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Energy Levels',
        description: null,
        icon: Icons.battery_charging_full_outlined,
      ),
      InsightItem(
        type: 'Graph',
        title: 'Sleep Duration',
        description: null,
        icon: Icons.nights_stay_outlined,
      ),
    ],
  ),
];
