import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_state.dart';
import '../models/faq_item.dart';
import '../repositories/faq_repository.dart';
import '../services/faq_search_engine.dart';
import '../../config/icebot_config.dart';
import 'package:flutter/foundation.dart';

class FaqChatController extends ChangeNotifier {
  final FaqRepository repository;
  final IcebotConfig config;

  FaqSearchEngine? _searchEngine;
  ChatState _state = const ChatState();

  FaqChatController({
    required this.repository,
    required this.config,
  });

  ChatState get state => _state;
  bool get isInitialized => _state.isInitialized;

  Future<void> initialize() async {
    if (_state.isInitialized) return;

    _updateState(_state.copyWith(isLoading: true));

    try {
      final faqs = await repository.loadFaqs();
      _searchEngine = FaqSearchEngine(faqs);

      final suggestions = _getSuggestions();

      _updateState(ChatState(
        messages: [_createWelcomeMessage()],
        suggestions: suggestions,
        isInitialized: true,
        isLoading: false,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _searchEngine == null) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    _updateState(_state.copyWith(
      messages: [..._state.messages, userMessage],
      isLoading: true,
    ));

    await Future.delayed(config.typingDelay);

    final matches = _searchEngine!.search(
      query: text,
      maxResults: 3,
      threshold: config.matchThreshold,
    );

    final botMessage = _createBotResponse(matches);
    final newSuggestions = _getContextualSuggestions(matches);

    _updateState(_state.copyWith(
      messages: [..._state.messages, botMessage],
      suggestions: newSuggestions,
      isLoading: false,
    ));
  }

  void selectSuggestion(FaqItem faq) {
    sendMessage(faq.question);
  }

  void clearChat() {
    _updateState(ChatState(
      messages: [_createWelcomeMessage()],
      suggestions: _getSuggestions(),
      isInitialized: true,
    ));
  }

  ChatMessage _createWelcomeMessage() {
    return ChatMessage(
      id: 'welcome',
      content: config.welcomeMessage,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
  }

  ChatMessage _createBotResponse(List<FaqItem> matches) {
    if (matches.isEmpty) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: config.noAnswerMessage,
        type: MessageType.bot,
        timestamp: DateTime.now(),
      );
    }

    final bestMatch = matches.first;
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: bestMatch.answer,
      type: MessageType.bot,
      timestamp: DateTime.now(),
      faqId: bestMatch.id,
      suggestedFaqIds: matches.skip(1).map((f) => f.id).toList(),
    );
  }

  List<FaqItem> _getSuggestions() {
    if (_searchEngine == null) return [];

    final pinned = _searchEngine!.getPinnedFaqs();
    if (pinned.length >= config.maxSuggestions) {
      return pinned.take(config.maxSuggestions).toList();
    }

    final trending = _searchEngine!.getTrendingFaqs(
      limit: config.maxSuggestions - pinned.length,
    );

    return [...pinned, ...trending].take(config.maxSuggestions).toList();
  }

  List<FaqItem> _getContextualSuggestions(List<FaqItem> recentMatches) {
    if (_searchEngine == null || recentMatches.isEmpty) {
      return _getSuggestions();
    }

    final related = _searchEngine!.getRelatedFaqs(
      recentMatches.first.id,
      limit: config.maxSuggestions,
    );

    return related.isNotEmpty ? related : _getSuggestions();
  }

  void _updateState(ChatState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
