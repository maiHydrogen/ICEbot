import 'package:flutter_test/flutter_test.dart';
import 'package:icebot/icebot.dart';

import 'support/faq_fixtures.dart';

FaqChatController _controller({IcebotConfig? config}) {
  return FaqChatController(
    repository: MemoryFaqRepository(sampleFaqs),
    config: config ?? const IcebotConfig(typingDelay: Duration.zero),
  );
}

void main() {
  group('initialize', () {
    test('emits a welcome message and pinned suggestions', () async {
      final c = _controller();
      await c.initialize();

      expect(c.isInitialized, isTrue);
      expect(c.state.messages.single.type, MessageType.bot);
      expect(c.state.messages.single.content, c.config.welcomeMessage);
      expect(c.state.suggestions, isNotEmpty);
      expect(c.state.error, isNull);
    });

    test('is idempotent', () async {
      final c = _controller();
      await c.initialize();
      await c.initialize();
      expect(c.state.messages.length, 1);
    });

    test('surfaces repository failures as an error, not a throw', () async {
      final c = FaqChatController(
        repository: ThrowingFaqRepository(),
        config: const IcebotConfig(typingDelay: Duration.zero),
      );

      await c.initialize();

      expect(c.state.error, isNotNull);
      expect(c.state.isLoading, isFalse);
      expect(c.isInitialized, isFalse);
    });
  });

  group('sendMessage', () {
    test('answers a matched question and links related FAQs', () async {
      final c = _controller();
      await c.initialize();

      await c.sendMessage('How do I reset my password?');

      final reply = c.state.messages.last;
      expect(reply.type, MessageType.bot);
      expect(reply.content, resetPassword.answer);
      expect(reply.faqId, '1');
      expect(reply.isUnanswered, isFalse);
    });

    test('flags an unmatched question and uses the fallback text', () async {
      final c = _controller();
      await c.initialize();

      await c.sendMessage('xylophone zephyr quokka');

      final reply = c.state.messages.last;
      expect(reply.content, c.config.noAnswerMessage);
      expect(reply.isUnanswered, isTrue);
    });

    test('ignores empty input', () async {
      final c = _controller();
      await c.initialize();
      final before = c.state.messages.length;

      await c.sendMessage('   ');

      expect(c.state.messages.length, before);
    });

    test('appends both the user message and the reply', () async {
      final c = _controller();
      await c.initialize();

      await c.sendMessage('forgot password');

      expect(c.state.messages[1].type, MessageType.user);
      expect(c.state.messages[2].type, MessageType.bot);
    });
  });

  group('escalation', () {
    test('escalateToSupport invokes the configured callback', () async {
      var called = 0;
      final c = _controller(
        config: IcebotConfig(
          typingDelay: Duration.zero,
          onEscalateToSupport: () => called++,
        ),
      );
      await c.initialize();

      c.escalateToSupport();

      expect(called, 1);
    });

    test('escalateToSupport is a no-op when no callback is set', () async {
      final c = _controller();
      await c.initialize();
      expect(c.escalateToSupport, returnsNormally);
    });
  });

  group('other behaviour', () {
    test('faqById returns null before initialization', () {
      expect(_controller().faqById('1'), isNull);
    });

    test('clearChat resets to a single welcome message', () async {
      final c = _controller();
      await c.initialize();
      await c.sendMessage('forgot password');

      c.clearChat();

      expect(c.state.messages.single.content, c.config.welcomeMessage);
      expect(c.isInitialized, isTrue);
    });

    test('selectSuggestion sends the FAQ question as a query', () async {
      final c = _controller();
      await c.initialize();

      c.selectSuggestion(resetPassword);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(c.state.messages.last.content, resetPassword.answer);
    });
  });
}
