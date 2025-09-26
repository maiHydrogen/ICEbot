import 'package:flutter/material.dart';

class ChatbotConfig {
  final String botName;
  final String welcomeMessage;
  final String noAnswerMessage;
  final Color primaryColor;
  final Color secondaryColor;
  final TextStyle? userMessageStyle;
  final TextStyle? botMessageStyle;
  final bool showTimestamp;
  final bool enableSuggestions;
  final int maxSuggestions;
  final Duration typingDelay;

  const ChatbotConfig({
    this.botName = 'Assistant',
    this.welcomeMessage = 'Hello! How can I help you today?',
    this.noAnswerMessage = 'I\'m sorry, I don\'t have an answer for that question.',
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.grey,
    this.userMessageStyle,
    this.botMessageStyle,
    this.showTimestamp = false,
    this.enableSuggestions = true,
    this.maxSuggestions = 3,
    this.typingDelay = const Duration(milliseconds: 1000),
  });
}
