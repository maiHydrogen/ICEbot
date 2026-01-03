import 'package:flutter/foundation.dart';
import 'chat_message.dart';
import 'faq_item.dart';

@immutable
class ChatState {
  final List<ChatMessage> messages;
  final List<FaqItem> suggestions;
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  const ChatState({
    this.messages = const [],
    this.suggestions = const [],
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    List<FaqItem>? suggestions,
    bool? isLoading,
    String? error,
    bool? isInitialized,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
