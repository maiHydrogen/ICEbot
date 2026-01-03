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

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.faqId,
    this.suggestedFaqIds,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? faqId,
    List<String>? suggestedFaqIds,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      faqId: faqId ?? this.faqId,
      suggestedFaqIds: suggestedFaqIds ?? this.suggestedFaqIds,
    );
  }
}
