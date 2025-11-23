import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walnut_home_page/models/missed_task.dart';

class MissedTasksHorizontalScroll extends StatelessWidget {
  final List<MissedTask> missedTasks;

  const MissedTasksHorizontalScroll({Key? key, required this.missedTasks})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Missed Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(onPressed: () {}, child: Text("View Details")),
            ],
          ),
        ),
        ...missedTasks.map((task) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: MissedTaskListRow(task: task),
          );
        }),
      ],
    );
  }
}

class MissedTaskListRow extends StatelessWidget {
  final MissedTask task;

  const MissedTaskListRow({super.key, required this.task});

  Color _color() {
    if (task.numberofdayspassedafterleaving <= 2) return Colors.orange;
    if (task.numberofdayspassedafterleaving <= 6) return Colors.deepOrange;
    return Colors.red;
  }

  String _emoji() {
    if (task.numberofdayspassedafterleaving <= 2) return "⚠️";
    if (task.numberofdayspassedafterleaving <= 6) return "🔥";
    return "⛔";
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // emoji urgency marker
          Text(_emoji(), style: const TextStyle(fontSize: 20)),

          const SizedBox(width: 12),

          // main text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task title
                Text(
                  task.shortTip,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // small impact text (secondary info)
                Text(
                  task.disadvantageofmissing,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // right side days missed
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${task.numberofdayspassedafterleaving}d",
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MissedTaskCard extends StatelessWidget {
  final MissedTask task;

  const MissedTaskCard({Key? key, required this.task}) : super(key: key);

  Color _getUrgencyColor() {
    if (task.numberofdayspassedafterleaving <= 3) {
      return Colors.orange;
    } else if (task.numberofdayspassedafterleaving <= 7) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  String _getUrgencyLabel() {
    if (task.numberofdayspassedafterleaving <= 3) {
      return 'Recent';
    } else if (task.numberofdayspassedafterleaving <= 7) {
      return 'Urgent';
    } else {
      return 'Critical';
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor();
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: urgencyColor.withOpacity(0.3), width: 1),
      ),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with urgency badge and days
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getUrgencyLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: urgencyColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: urgencyColor),
                      const SizedBox(width: 4),
                      Text(
                        '${task.numberofdayspassedafterleaving}d',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: urgencyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Task title
            Text(
              task.shortTip,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Date missed
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(task.datemissed),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Divider
            Divider(color: Colors.grey[300], height: 1),
            const SizedBox(height: 10),

            // Impact section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: urgencyColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.disadvantageofmissing,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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

class ShowLifeStyleUI extends StatefulWidget {
  const ShowLifeStyleUI({super.key});

  @override
  State<ShowLifeStyleUI> createState() => _ShowLifeStyleUIState();
}

class _ShowLifeStyleUIState extends State<ShowLifeStyleUI> {
  final missedTasksList = [
    MissedTask(
      shortTip: 'Take Vitamin D Supplement',
      datemissed: DateTime.now().subtract(const Duration(days: 2)),
      numberofdayspassedafterleaving: 2,
      disadvantageofmissing:
          'Prolonged deficiency may weaken bones and immune system',
    ),

    MissedTask(
      shortTip: 'Morning Walk / Cardio',
      datemissed: DateTime.now().subtract(const Duration(days: 1)),
      numberofdayspassedafterleaving: 1,
      disadvantageofmissing:
          'Skipping cardio reduces stamina and increases risk of weight gain',
    ),

    MissedTask(
      shortTip: 'Drink 2L of Water',
      datemissed: DateTime.now().subtract(const Duration(days: 3)),
      numberofdayspassedafterleaving: 3,
      disadvantageofmissing:
          'Dehydration can cause fatigue, headaches, and poor focus',
    ),

    MissedTask(
      shortTip: 'Track Daily Calories',
      datemissed: DateTime.now().subtract(const Duration(days: 4)),
      numberofdayspassedafterleaving: 4,
      disadvantageofmissing:
          'Inconsistent tracking may lead to overeating and slow progress',
    ),

    MissedTask(
      shortTip: '8 Hours of Sleep',
      datemissed: DateTime.now().subtract(const Duration(days: 1)),
      numberofdayspassedafterleaving: 1,
      disadvantageofmissing:
          'Poor sleep affects mood, metabolism, and cognitive performance',
    ),

    MissedTask(
      shortTip: 'Meditation / Stress Relief',
      datemissed: DateTime.now().subtract(const Duration(days: 5)),
      numberofdayspassedafterleaving: 5,
      disadvantageofmissing:
          'Missing stress-relief sessions can increase anxiety and tension',
    ),

    MissedTask(
      shortTip: 'Take Magnesium Supplement',
      datemissed: DateTime.now().subtract(const Duration(days: 6)),
      numberofdayspassedafterleaving: 6,
      disadvantageofmissing:
          'Low magnesium may cause muscle cramps and poor sleep quality',
    ),

    MissedTask(
      shortTip: 'Do Strength Training',
      datemissed: DateTime.now().subtract(const Duration(days: 3)),
      numberofdayspassedafterleaving: 3,
      disadvantageofmissing:
          'Skipping workouts slows muscle growth and reduces metabolism',
    ),

    MissedTask(
      shortTip: 'Check Blood Pressure',
      datemissed: DateTime.now().subtract(const Duration(days: 7)),
      numberofdayspassedafterleaving: 7,
      disadvantageofmissing:
          'Not monitoring BP may hide early signs of hypertension',
    ),

    MissedTask(
      shortTip: 'Eat a Healthy Breakfast',
      datemissed: DateTime.now().subtract(const Duration(days: 1)),
      numberofdayspassedafterleaving: 1,
      disadvantageofmissing:
          'Skipping breakfast affects energy, focus, and blood sugar levels',
    ),

    MissedTask(
      shortTip: 'Drink Herbal Tea at Night',
      datemissed: DateTime.now().subtract(const Duration(days: 2)),
      numberofdayspassedafterleaving: 2,
      disadvantageofmissing:
          'Missing this may cause higher stress and difficulty sleeping',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MissedTasksHorizontalScroll(missedTasks: missedTasksList);
  }
}

class MissedTaskBubble extends StatelessWidget {
  final MissedTask task;

  const MissedTaskBubble({super.key, required this.task});

  Color _urgencyColor() {
    if (task.numberofdayspassedafterleaving <= 3) return Colors.orange;
    if (task.numberofdayspassedafterleaving <= 7) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _urgencyIcon() {
    if (task.numberofdayspassedafterleaving <= 3) return Icons.circle;
    if (task.numberofdayspassedafterleaving <= 7) return Icons.notifications;
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _urgencyColor();

    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Days Missed (Top row)
          Row(
            children: [
              Icon(_urgencyIcon(), color: color, size: 20),
              const Spacer(),
              Text(
                '${task.numberofdayspassedafterleaving}d',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Task short tip
          Text(
            task.shortTip,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          // Tiny subtle hint bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Missed task",
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
