enum MessageType { user, bot, suggestion }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? faqId;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    DateTime? timestamp,
    this.faqId,
  }) : timestamp = timestamp ?? DateTime.now();
}
