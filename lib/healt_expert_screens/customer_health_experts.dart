import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/healt_expert_screens/customer_health_expert_details.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';

class CustomerHealthExperts extends StatefulWidget {
  const CustomerHealthExperts({super.key});

  @override
  State<CustomerHealthExperts> createState() => _CustomerHealthExpertsState();
}

class _CustomerHealthExpertsState extends State<CustomerHealthExperts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CustomerHealthExperts')),
      body: Consumer<CustomerHealthExpertProvider>(
        builder: (context, value, child) {
          log("the value of length is ${value.expertslist.length}");

          return Column(
            children: [
              ...value.expertslist.map(
                (item) => ExpertProfileCard(expert: item),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExpertProfileCard extends StatelessWidget {
  final HealthExpert expert;

  const ExpertProfileCard({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomerHealthExpertDetails(expert: expert),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(expert.imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expert.type,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expert.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    expert.description.split(',')[0],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.4,
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
