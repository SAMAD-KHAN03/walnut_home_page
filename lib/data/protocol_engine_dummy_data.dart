
// Dummy Data
import 'package:walnut_home_page/models/protocol_engine.dart';
import 'package:flutter/material.dart';

ProtocolEngine getDummyProtocol() {
  return ProtocolEngine(
    name: 'Metabolic Flexibility Protocol',
    duration: '90 Days',
    startingDate: '2024-01-01',
    personName: 'Sarah',
    currentDay: 42,
    summary:
        'This protocol shifts your baseline energy utilization to optimize for longevity and performance, specifically targeting mitochondrial density.',
    summaryTags: ['VO2 Max Focus', 'Deep Sleep', 'Cortisol Mgmt'],
    healthAreas: [
      HealthArea(
        name: 'Cardiovascular',
        status: 'Excellent',
        value: '92',
        icon: Icons.favorite_outline,
        color: const Color(0xFF11D473),
        trend: '+4.2%',
        trendType: TrendType.up,
      ),
      HealthArea(
        name: 'Recovery',
        status: 'Improving',
        value: '78',
        icon: Icons.bedtime_outlined,
        color: Colors.orange,
        trend: 'Stable',
        trendType: TrendType.flat,
      ),
      HealthArea(
        name: 'Metabolic',
        status: 'Excellent',
        value: '88',
        icon: Icons.bolt_outlined,
        color: Colors.blue,
        trend: '+3.1%',
        trendType: TrendType.up,
      ),
      HealthArea(
        name: 'Stress',
        status: 'Improving',
        value: '65',
        icon: Icons.psychology_outlined,
        color: Colors.purple,
        trend: '+5.3%',
        trendType: TrendType.up,
      ),
    ],
    protocolPhases: [
      ProtocolPhase(
        type: ProtocolPhaseType.foundation,
        range: 'Days 1-30',
        summary: 'Stabilize sleep timing, reduce inflammatory load, establish basic movement & hydration routines',
      ),
      ProtocolPhase(
        type: ProtocolPhaseType.acceleration,
        range: 'Days 31-60',
        summary: 'Improve insulin sensitivity, cardiovascular fitness, and increase strength & recovery capacity',
      ),
      ProtocolPhase(
        type: ProtocolPhaseType.optimization,
        range: 'Days 61-90',
        summary: 'Lock in habits, improve long-term biomarkers, and transition to maintenance lifestyle',
      ),
    ],
  );
}