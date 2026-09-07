import 'package:flutter_test/flutter_test.dart';
import 'package:icebot/src/core/services/string_matcher.dart';

void main() {
  group('StringMatcher.normalize', () {
    test('lowercases, strips punctuation and collapses whitespace', () {
      expect(
        StringMatcher.normalize('  How do I  RESET my password?! '),
        'how do i reset my password',
      );
    });

    test('empty and punctuation-only strings normalize to empty', () {
      expect(StringMatcher.normalize(''), '');
      expect(StringMatcher.normalize('!!! ??? ...'), '');
    });
  });

  group('StringMatcher.tokenize', () {
    test('splits on whitespace and drops single-character tokens', () {
      expect(StringMatcher.tokenize('I do reset a password'), [
        'do',
        'reset',
        'password',
      ]);
    });
  });

  group('StringMatcher.calculateSimilarity', () {
    test('identical strings score 1.0', () {
      expect(StringMatcher.calculateSimilarity('hello', 'hello'), 1.0);
    });

    test('either string empty scores 0.0', () {
      expect(StringMatcher.calculateSimilarity('', 'hello'), 0.0);
      expect(StringMatcher.calculateSimilarity('hello', ''), 0.0);
    });

    test('one edit in a five-character string scores 0.8', () {
      expect(
        StringMatcher.calculateSimilarity('hello', 'hallo'),
        closeTo(0.8, 1e-9),
      );
    });

    test('is case-insensitive', () {
      expect(StringMatcher.calculateSimilarity('Hello', 'hello'), 1.0);
    });

    test('score decreases as strings diverge', () {
      final near = StringMatcher.calculateSimilarity('password', 'passcode');
      final far = StringMatcher.calculateSimilarity('password', 'elephant');
      expect(near, greaterThan(far));
    });
  });
}
