import 'package:flutter/material.dart';

@immutable
class ChatTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color userBubbleColor;
  final Color botBubbleColor;
  final Color backgroundColor;
  final TextStyle userTextStyle;
  final TextStyle botTextStyle;
  final TextStyle timestampStyle;
  final double borderRadius;
  final double bubbleElevation;

  const ChatTheme({
    this.primaryColor = const Color(0xFFEE1C22),
    this.secondaryColor = const Color(0xFF730F11),
    this.userBubbleColor = Colors.white,
    this.botBubbleColor = const Color(0xFFF5F5F5),
    this.backgroundColor = Colors.white,
    this.userTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 14,
    ),
    this.botTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 14,
    ),
    this.timestampStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 11,
    ),
    this.borderRadius = 16.0,
    this.bubbleElevation = 0.0,
  });

  factory ChatTheme.fromColorScheme(ColorScheme scheme) {
    return ChatTheme(
      primaryColor: scheme.primary,
      secondaryColor: scheme.secondary,
      userBubbleColor: scheme.primaryContainer,
      botBubbleColor: scheme.surfaceVariant,
      backgroundColor: scheme.background,
    );
  }
}
