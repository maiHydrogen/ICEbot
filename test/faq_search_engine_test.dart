import 'package:flutter_test/flutter_test.dart';
import 'package:icebot/src/core/services/faq_search_engine.dart';

import 'support/faq_fixtures.dart';

void main() {
  final engine = FaqSearchEngine(sampleFaqs);

  group('search', () {
    test('returns nothing for a blank query', () {
      expect(engine.search(query: '   '), isEmpty);
    });

    test('exact question text is the top result', () {
      final results = engine.search(query: 'How do I reset my password?');
      expect(results.first.id, '1');
    });

    test('matches on overlapping keywords', () {
      final results = engine.search(query: 'forgot password');
      expect(results.first.id, '1');
    });

    test('matches an alternative phrasing', () {
      final results = engine.search(query: 'I forgot my password');
      expect(results.first.id, '1');
    });

    test('returns empty when nothing is relevant', () {
      expect(engine.search(query: 'weather forecast tomorrow'), isEmpty);
    });

    test('respects maxResults', () {
      final results = engine.search(query: 'how do i', maxResults: 1);
      expect(results.length, lessThanOrEqualTo(1));
    });

    test('category scopes the candidate set', () {
      final results = engine.search(
        query: 'how do i contact support',
        category: 'Account',
      );
      expect(results.every((f) => f.category == 'Account'), isTrue);
      expect(results.any((f) => f.id == '4'), isFalse);
    });
  });

  group('curated lists', () {
    test('getPinnedFaqs returns only pinned items', () {
      expect(engine.getPinnedFaqs().map((f) => f.id).toSet(), {'1', '3'});
    });

    test('getTrendingFaqs is ordered by popularity', () {
      final trending = engine.getTrendingFaqs(limit: 2);
      expect(trending.map((f) => f.id).toList(), ['1', '2']);
    });

    test('getRelatedFaqs resolves relatedQuestionIds', () {
      expect(engine.getRelatedFaqs('1').map((f) => f.id).toList(), ['2']);
    });

    test('getRelatedFaqs is empty for an unknown id', () {
      expect(engine.getRelatedFaqs('nope'), isEmpty);
    });

    test('getCategories returns a sorted, de-duplicated list', () {
      expect(engine.getCategories(), ['Account', 'Support']);
    });

    test('getFaqById looks items up by id', () {
      expect(engine.getFaqById('2')?.id, '2');
      expect(engine.getFaqById('missing'), isNull);
    });
  });
}
