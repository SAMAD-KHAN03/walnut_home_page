import 'package:walnut_home_page/all_screen.dart';

final List<ChatMessage> initialMessages = [
      ChatMessage(
        text: "Good morning! How are you feeling today?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "I'm feeling a little stressed.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      // Responsive message mimicking the screenshot
      ChatMessage(
        text: "I'm sorry to hear that. Would you like to try a quick breathing exercise to help calm your mind?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        type: 'responsive',
        responseOptions: ["Yes, start exercise", "No, thanks"],
      ),
      // Example of a previously sent plain message
      ChatMessage(
        text: "That's helpful. I completed my workout today.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ChatMessage(
        text: "Great job on completing your workout! Consistency is key.",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        type: 'plain',
      ),
    ];