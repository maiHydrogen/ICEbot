import 'package:flutter/foundation.dart';

enum MessageType { user, bot, system }

@immutable
class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? faqId;
  final List<String>? suggestedFaqIds;

  /// True for a bot message that could not be matched to any FAQ. The UI uses
  /// this to offer a "contact support" action.
  final bool isUnanswered;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.faqId,
    this.suggestedFaqIds,
    this.isUnanswered = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? faqId,
    List<String>? suggestedFaqIds,
    bool? isUnanswered,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      faqId: faqId ?? this.faqId,
      suggestedFaqIds: suggestedFaqIds ?? this.suggestedFaqIds,
      isUnanswered: isUnanswered ?? this.isUnanswered,
    );
  }
}
