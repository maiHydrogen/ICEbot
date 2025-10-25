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
    this.botName = 'ICEBot',
    this.welcomeMessage = 'Hello! I\'m ICEBot, Please choose one of the following categories that suits your query or just type your own query?',
    this.noAnswerMessage = 'I\'m sorry, I don\'t have an answer for that question.',
    this.primaryColor = const Color.fromARGB(1, 238, 28, 34),
    this.secondaryColor = const Color.fromARGB(1, 115, 15, 17),
    this.userMessageStyle,
    this.botMessageStyle,
    this.showTimestamp = false,
    this.enableSuggestions = true,
    this.maxSuggestions = 3,
    this.typingDelay = const Duration(milliseconds: 100),
  });
}
