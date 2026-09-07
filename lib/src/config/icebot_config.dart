import 'package:flutter/foundation.dart';

@immutable
class IcebotConfig {
  final String botName;
  final String welcomeMessage;
  final String noAnswerMessage;
  final Duration typingDelay;

  /// Number of suggestion chips shown below the conversation.
  final int maxSuggestions;

  /// Maximum number of FAQ matches considered per query. The best match becomes
  /// the answer; the rest are offered as "related" chips.
  final int maxResults;

  final double matchThreshold;
  final bool showTimestamp;

  /// Invoked when the user taps "Contact support" on an unanswered question.
  /// When null, no escalation action is shown.
  final VoidCallback? onEscalateToSupport;

  const IcebotConfig({
    this.botName = 'ICEbot',
    this.welcomeMessage = 'Hello! I\'m ICEbot. How can I help you today?',
    this.noAnswerMessage =
        'I\'m sorry, I don\'t have an answer for that. '
        'Please contact our support team for assistance.',
    this.typingDelay = const Duration(milliseconds: 500),
    this.maxSuggestions = 3,
    this.maxResults = 3,
    this.matchThreshold = 0.3,
    this.showTimestamp = false,
    this.onEscalateToSupport,
  });

  IcebotConfig copyWith({
    String? botName,
    String? welcomeMessage,
    String? noAnswerMessage,
    Duration? typingDelay,
    int? maxSuggestions,
    int? maxResults,
    double? matchThreshold,
    bool? showTimestamp,
    VoidCallback? onEscalateToSupport,
  }) {
    return IcebotConfig(
      botName: botName ?? this.botName,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      noAnswerMessage: noAnswerMessage ?? this.noAnswerMessage,
      typingDelay: typingDelay ?? this.typingDelay,
      maxSuggestions: maxSuggestions ?? this.maxSuggestions,
      maxResults: maxResults ?? this.maxResults,
      matchThreshold: matchThreshold ?? this.matchThreshold,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      onEscalateToSupport: onEscalateToSupport ?? this.onEscalateToSupport,
    );
  }
}
