import 'package:flutter_test/flutter_test.dart';
import 'package:icebot/icebot.dart';

void main() {
  group('FaqItem.fromJson', () {
    test('reads every field', () {
      final item = FaqItem.fromJson(const {
        'id': 7,
        'question': 'Q?',
        'answer': 'A.',
        'keywords': ['k1', 'k2'],
        'alternativeQuestions': ['alt'],
        'category': 'Cat',
        'popularity': 42,
        'isPinned': true,
        'relatedQuestionIds': ['1', '2'],
        'createdAt': '2024-01-02T03:04:05.000Z',
        'updatedAt': '2024-02-03T04:05:06.000Z',
      });

      expect(item.id, '7'); // coerced from int
      expect(item.question, 'Q?');
      expect(item.keywords, ['k1', 'k2']);
      expect(item.alternativeQuestions, ['alt']);
      expect(item.category, 'Cat');
      expect(item.popularity, 42);
      expect(item.isPinned, isTrue);
      expect(item.relatedQuestionIds, ['1', '2']);
      expect(item.createdAt, DateTime.utc(2024, 1, 2, 3, 4, 5));
      expect(item.updatedAt, DateTime.utc(2024, 2, 3, 4, 5, 6));
    });

    test('applies defaults for omitted optional fields', () {
      final item = FaqItem.fromJson(const {
        'id': '1',
        'question': 'Q?',
        'answer': 'A.',
      });

      expect(item.keywords, isEmpty);
      expect(item.alternativeQuestions, isEmpty);
      expect(item.category, isNull);
      expect(item.popularity, 0);
      expect(item.isPinned, isFalse);
      expect(item.relatedQuestionIds, isEmpty);
      expect(item.createdAt, isNull);
    });

    test('tolerates missing required fields with empty strings', () {
      final item = FaqItem.fromJson(const {});
      expect(item.id, '');
      expect(item.question, '');
      expect(item.answer, '');
    });
  });

  group('toJson', () {
    test('round-trips through fromJson', () {
      const original = FaqItem(
        id: '1',
        question: 'Q?',
        answer: 'A.',
        keywords: ['k'],
        alternativeQuestions: ['alt'],
        category: 'Cat',
        popularity: 5,
        isPinned: true,
        relatedQuestionIds: ['2'],
      );

      final restored = FaqItem.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.question, original.question);
      expect(restored.keywords, original.keywords);
      expect(restored.category, original.category);
      expect(restored.popularity, original.popularity);
      expect(restored.isPinned, original.isPinned);
      expect(restored.relatedQuestionIds, original.relatedQuestionIds);
    });

    test('omits null category and timestamps', () {
      const item = FaqItem(id: '1', question: 'Q?', answer: 'A.');
      final json = item.toJson();
      expect(json.containsKey('category'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
      expect(json.containsKey('updatedAt'), isFalse);
    });
  });

  group('equality', () {
    test('items are equal when their ids match', () {
      const a = FaqItem(id: '1', question: 'Q1', answer: 'A1');
      const b = FaqItem(
        id: '1',
        question: 'different',
        answer: 'also different',
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('items differ when their ids differ', () {
      const a = FaqItem(id: '1', question: 'Q', answer: 'A');
      const b = FaqItem(id: '2', question: 'Q', answer: 'A');
      expect(a, isNot(equals(b)));
    });
  });
}
