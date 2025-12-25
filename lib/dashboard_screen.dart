import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/whh.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';
import 'package:walnut_home_page/health_analytics_dashboard/four_dimension_user_info_dashboard.dart';
import 'package:walnut_home_page/planscreen/plans_screen.dart';
import 'package:walnut_home_page/protocol_engine/daily_task_screen.dart';
import 'package:walnut_home_page/protocol_engine/protocol_engine_dashboard.dart';
import 'package:walnut_home_page/protocol_engine/protocol_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';
import 'package:walnut_home_page/health_analytics_dashboard/four_dimension_user_info_dashboard.dart';
import 'package:walnut_home_page/planscreen/plans_screen.dart';
import 'package:walnut_home_page/theme/themes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Tasks Today',
      debugShowCheckedModeBanner: false,
      theme: lighttheme,
      darkTheme: darktheme,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DailyTasksScreen(),
    // const PlansScreen(),
    const ProtocolEngineDashboard(),
    const FourDimensionUserInfoDashboard(),
    // const ProgressScreen(),
    const HealthExpert_Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Daily Tasks Today')),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        // selectedLabelStyle: TextStyle(
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Iconify(Ph.brain),
            label: 'Protocol Engine',
          ),

          BottomNavigationBarItem(
            icon: Iconify(Healthicons.respirology_outline),
            label: 'HealtStats',
          ),

          BottomNavigationBarItem(
            icon: Iconify(Mdi.doctor),
            label: 'Health Experts',
          ),
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
