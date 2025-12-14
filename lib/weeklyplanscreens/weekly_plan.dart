import 'package:flutter/material.dart';
import 'package:walnut_home_page/data/monthly_dummy_data.dart';
import 'package:walnut_home_page/data/weekly_dummy_data.dart';
import 'package:walnut_home_page/models/weekly_tasks_info.dart';

class WeeklyMonthlyTaskScreen extends StatefulWidget {
  const WeeklyMonthlyTaskScreen({super.key});

  @override
  State<WeeklyMonthlyTaskScreen> createState() =>
      _WeeklyMonthlyTaskScreenState();
}

class _WeeklyMonthlyTaskScreenState extends State<WeeklyMonthlyTaskScreen> {
  var tasklist = weeklydata;
  bool isWeekly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const Text(
                "Your Wellness Tasks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),

              // WEEK / MONTH TOGGLE
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "This Week",
                      isSelected: isWeekly,
                      onPressed: () {
                        setState(() {
                          isWeekly = true;
                          tasklist = weeklydata;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: "This Month",
                      isSelected: !isWeekly,
                      onPressed: () {
                        setState(() {
                          isWeekly = false;
                          tasklist = monthlydata;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // TASK LIST
              Expanded(child: TasklistElement(task: tasklist)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------
//   BEAUTIFUL TASK LIST
// ------------------------------------------------------

class TasklistElement extends StatelessWidget {
  final List<WeeklyMonthlyTasksInfo> task;

  const TasklistElement({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: task.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            leading: Text(
              task[index].icons,
              style: const TextStyle(fontSize: 28),
            ),
            title: Text(
              task[index].name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              task[index].freq,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 26,
            ),
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------
//   BEAUTIFUL CUSTOM BUTTON
// ------------------------------------------------------

class CustomButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00BFA5) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF00BFA5) : Colors.grey.shade300,
          width: 1.4,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF00BFA5).withOpacity(0.35),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
