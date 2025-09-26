import 'package:flutter/material.dart';
import 'package:icebot/index.dart';

class ChatService extends ChangeNotifier {
  final FAQService _faqService;
  final List<ChatMessage> _messages = [];
  final ChatbotConfig config;

  ChatService(this._faqService, this.config) {
    _addWelcomeMessage();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: config.welcomeMessage,
      type: MessageType.bot,
    ));
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.user,
    );
    _messages.add(userMessage);
    notifyListeners();

    // Add typing delay
    await Future.delayed(config.typingDelay);

    // Search for FAQ answer
    final faqs = _faqService.searchFAQs(content);
    String botResponse;
    String? faqId;

    if (faqs.isNotEmpty) {
      botResponse = faqs.first.answer;
      faqId = faqs.first.id;
    } else {
      botResponse = config.noAnswerMessage;
    }

    // Add bot response
    final botMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: botResponse,
      type: MessageType.bot,
      faqId: faqId,
    );
    _messages.add(botMessage);
    notifyListeners();
  }

  void selectSuggestion(FAQItem faq) {
    sendMessage(faq.question);
  }

  void clearChat() {
    _messages.clear();
    _addWelcomeMessage();
  }
}
