import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';

class UtilityFunctionClass {
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static void launchGoogleMeet(String meetUrl) async {
    final Uri url = Uri.parse(meetUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 👈 this is key
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static void navigateToDetails(HealthExpert expert, BuildContext context,bool showButton) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HealthExpertDetailScreen(expert: expert, showAddButton: showButton),
      ),
    );
  }

  static String formatType(String type) {
    switch (type) {
      case 'fitnessCoach':
        return 'Fitness Coach';
      case 'gynecologist':
        return 'Gynecologist';
      case 'andrologist':
        return 'Andrologist';
      case 'psyotherapist':
        return 'Psychotherapist';
      default:
        return type;
    }
  }

  static Widget buildExpertCard(HealthExpert expert, BuildContext context,bool showButton) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => navigateToDetails(expert, context,showButton),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(expert.imageUrl),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expert.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatType(expert.type),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Container(
                      // width: 40,
                      height: 30,
                      decoration: BoxDecoration(color: Colors.green),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Icon(Icons.star, size: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Text(
                                expert.rating,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              Divider(thickness: 2, color: Colors.grey),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Icon(Icons.location_on), Text(expert.location)],
              ),
              Text(
                "Recent Webinar ${UtilityFunctionClass.formatDateTime(expert.latestwebinar)}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
