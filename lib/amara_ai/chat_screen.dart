import 'package:flutter/material.dart';

//mater =========
//============ MESSAGE MODEL (UPDATED) =====================
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? responseOptions; // Options for a responsive AI message
  final String type; // 'plain' or 'responsive'
  bool optionsActive; // To track if options have been picked

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.responseOptions,
    this.type = 'plain',
    this.optionsActive = true,
  });

  // Helper method to create a copy for state updates
  ChatMessage copyWith({
    String? text,
    List<String>? responseOptions,
    bool? optionsActive,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      responseOptions: responseOptions ?? this.responseOptions,
      type: type,
      optionsActive: optionsActive ?? this.optionsActive,
    );
  }
}

// ===================== CHAT BUBBLE (FIXED) =====================
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onOptionSelected;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (Avatar and Message Bubble code remains the same) ...

    // Logic to simulate the avatar based on screenshot (simple colored circle)
    Widget auraAvatar = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          // Placeholder for the actual avatar image
          image: NetworkImage(
            "https://picsum.photos/36?random=${message.timestamp.millisecondsSinceEpoch}",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[auraAvatar, const SizedBox(width: 8)],

          Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Avatar Name/Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  message.isUser ? "You" : "Amara",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),

              // Message Bubble
              Container(
                constraints: BoxConstraints(
                  // The constraints here are already correct (max 75% of screen width)
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? const Color(0xFF00BFA5)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SelectableText(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black87,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),

              // --- RESPONSIVE OPTIONS (FIX APPLIED HERE) ---
              if (!message.isUser &&
                  message.type == 'responsive' &&
                  message.responseOptions != null &&
                  message.optionsActive) ...[
                const SizedBox(height: 12),

                // FIX: Wrap the Row in a SingleChildScrollView for horizontal scrolling
                SizedBox(
                  // Constrain the width of the SingleChildScrollView to the bubble's width
                  width:
                      MediaQuery.of(context).size.width * 0.75 -
                      44, // 0.75 width minus avatar/padding/spacing
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: message.responseOptions!
                          .map(
                            (action) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                onPressed: () => onOptionSelected(action),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      action.toLowerCase().contains("yes") ||
                                          action.toLowerCase().contains("start")
                                      ? const Color(0xFF00BFA5)
                                      : Colors.white,
                                  foregroundColor:
                                      action.toLowerCase().contains("yes") ||
                                          action.toLowerCase().contains("start")
                                      ? Colors.white
                                      : Colors.black87,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color:
                                          action.toLowerCase().contains(
                                                "yes",
                                              ) ||
                                              action.toLowerCase().contains(
                                                "start",
                                              )
                                          ? const Color(0xFF00BFA5)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  action,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== CHAT SCREEN (REVISED) =====================
class ChatScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData? leadingIcon;
  final List<ChatMessage> initialMessages;

  const ChatScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    this.leadingIcon = Icons.psychology,
    this.initialMessages = const [],
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  bool _isTyping = false;
  String _streamingText = "";
  int _aiResponseCount = 0; // To alternate response types

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleOptionSelected(int messageIndex, String selectedOption) {
    if (_isTyping) return;

    // 1. Deactivate options for the AI message
    setState(() {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        optionsActive: false,
      );
    });

    // 2. Simulate user sending the selected option as a new message
    _sendMessage(selectedOption, simulateResponse: true);
  }

  Future<void> _sendMessage(
    String text, {
    bool simulateResponse = false,
  }) async {
    final userMessage = text.trim();
    if (userMessage.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _messageController.clear();
      _scrollToBottom();
    });

    if (simulateResponse) {
      await _simulateAIResponse(userMessage);
    }
  }

  Future<void> _simulateAIResponse(String userMessage) async {
    _aiResponseCount++;
    setState(() => _isTyping = true);

    // Add Thinking message
    _messages.add(
      ChatMessage(text: "...", isUser: false, timestamp: DateTime.now()),
    );
    _scrollToBottom();
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));
    _messages.removeLast(); // Remove "..."

    // Example logic: Alternate between responsive and plain
    bool isResponsive = _aiResponseCount % 2 == 1;

    String responseText;
    List<String>? options;

    if (isResponsive) {
      responseText =
          "I see. To help you manage your weight, should we focus on a 'Nutrition Plan' or a 'Workout Schedule' first?";
      options = ["Nutrition Plan", "Workout Schedule"];
    } else {
      responseText =
          "Got it. I'll search for the best fitness coaches in your area specializing in weight reduction. I recommend Dr. Neel Rajan and his team.";
      options = null;
    }

    _streamingText = "";
    _messages.add(
      ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
        type: isResponsive ? 'responsive' : 'plain',
        responseOptions: options,
        optionsActive: true,
      ),
    );
    setState(() {});

    for (int i = 0; i < responseText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      _streamingText = responseText.substring(0, i + 1);
      setState(() {
        _messages[_messages.length - 1] = _messages[_messages.length - 1]
            .copyWith(text: _streamingText);
      });
      _scrollToBottom();
    }

    setState(() => _isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                widget.leadingIcon ?? Icons.chat,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => ChatBubble(
                message: _messages[index],
                onOptionSelected: (option) =>
                    _handleOptionSelected(index, option),
              ),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TypingIndicator(),
            ),
          _buildAdditionalFeatures(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAdditionalFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description, size: 20),
            label: const Text("Get Daily Summary"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.sentiment_satisfied_alt, "Log Mood"),
                _buildActionButton(Icons.notifications_none, "Set Reminder"),
                _buildActionButton(Icons.share, "Share Progress"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          textStyle: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.grey.shade600,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Chat with Amara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_upward),
              color: Colors.white,
              onPressed: () =>
                  _sendMessage(_messageController.text, simulateResponse: true),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== TYPING INDICATOR =====================
// (No changes needed, kept for completeness)
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 60.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(radius: 3, backgroundColor: Colors.teal),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(radius: 3, backgroundColor: Colors.teal),
          ),
          CircleAvatar(radius: 3, backgroundColor: Colors.teal),
        ],
      ),
    );
  }
}