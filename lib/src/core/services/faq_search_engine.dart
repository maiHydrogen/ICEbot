import '../models/faq_item.dart';
import 'string_matcher.dart';

class SearchResult {
  final FaqItem faq;
  final double score;
  final String matchType;

  const SearchResult(this.faq, this.score, this.matchType);
}

class FaqSearchEngine {
  final List<FaqItem> _allFaqs;
  final Map<String, List<FaqItem>> _categoryIndex = {};
  final Map<String, FaqItem> _idIndex = {};

  FaqSearchEngine(this._allFaqs) {
    _buildIndexes();
  }

  void _buildIndexes() {
    _categoryIndex.clear();
    _idIndex.clear();

    for (final faq in _allFaqs) {
      _idIndex[faq.id] = faq;
      final category = faq.category ?? 'General';
      _categoryIndex.putIfAbsent(category, () => []).add(faq);
    }
  }

  List<FaqItem> search({
    required String query,
    String? category,
    int maxResults = 5,
    double threshold = 0.3,
  }) {
    if (query.trim().isEmpty) return [];

    final candidates = category != null && _categoryIndex.containsKey(category)
        ? _categoryIndex[category]!
        : _allFaqs;

    final results = <SearchResult>[];
    final queryLower = query.toLowerCase().trim();
    final queryNormalized = StringMatcher.normalize(query);
    final queryTokens = StringMatcher.tokenize(query);

    for (final faq in candidates) {
      SearchResult? result = _matchFaq(
        faq,
        queryLower,
        queryNormalized,
        queryTokens,
        threshold,
      );

      if (result != null) {
        results.add(result);
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(maxResults).map((r) => r.faq).toList();
  }

  SearchResult? _matchFaq(
      FaqItem faq,
      String queryLower,
      String queryNormalized,
      List<String> queryTokens,
      double threshold,
      ) {
    final questionLower = faq.question.toLowerCase().trim();
    final questionNormalized = StringMatcher.normalize(faq.question);

    // Strategy 1: Exact match
    if (queryLower == questionLower) {
      return SearchResult(faq, 1.0, 'exact_match');
    }

    // Strategy 2: Normalized exact match
    if (questionNormalized == queryNormalized) {
      return SearchResult(faq, 0.99, 'normalized_exact');
    }

    // Strategy 3: Substring match
    if (questionNormalized.contains(queryNormalized) && queryNormalized.length > 5) {
      return SearchResult(faq, 0.95, 'question_contains_query');
    }
    if (queryNormalized.contains(questionNormalized) && questionNormalized.length > 5) {
      return SearchResult(faq, 0.93, 'query_contains_question');
    }

    // Strategy 4: Alternative questions match
    for (final alt in faq.alternativeQuestions) {
      final altLower = alt.toLowerCase().trim();
      final altNormalized = StringMatcher.normalize(alt);

      if (queryLower == altLower || queryNormalized == altNormalized) {
        return SearchResult(faq, 0.98, 'exact_alternative');
      }

      if (altNormalized.contains(queryNormalized) && queryNormalized.length > 5) {
        return SearchResult(faq, 0.92, 'alternative_contains');
      }
    }

    // Strategy 5: Multiple keyword matches
    int keywordMatches = 0;
    for (final keyword in faq.keywords) {
      final kwLower = keyword.toLowerCase().trim();
      if (queryLower.contains(kwLower) || kwLower.contains(queryLower)) {
        keywordMatches++;
      }
    }

    if (keywordMatches >= 2) {
      final ratio = keywordMatches / faq.keywords.length;
      return SearchResult(faq, 0.85 * ratio, 'multi_keywords');
    }

    // Strategy 6: Token overlap
    if (queryTokens.length >= 2) {
      final questionTokens = StringMatcher.tokenize(faq.question);
      int tokenMatches = 0;

      for (final qt in queryTokens) {
        if (questionTokens.contains(qt)) {
          tokenMatches++;
        }
      }

      if (tokenMatches >= 2) {
        final ratio = tokenMatches / queryTokens.length;
        if (ratio >= 0.5) {
          return SearchResult(faq, 0.75 * ratio, 'token_overlap');
        }
      }
    }

    // Strategy 7: Fuzzy similarity
    final similarity = StringMatcher.calculateSimilarity(
      queryNormalized,
      questionNormalized,
    );

    if (similarity >= 0.7) {
      return SearchResult(faq, similarity * 0.7, 'high_similarity');
    }

    // Strategy 8: Single keyword fallback
    if (keywordMatches == 1 && queryTokens.length <= 2) {
      return SearchResult(faq, 0.4, 'single_keyword');
    }

    return null;
  }

  List<FaqItem> getPinnedFaqs() {
    return _allFaqs.where((faq) => faq.isPinned).toList();
  }

  List<FaqItem> getTrendingFaqs({int limit = 5}) {
    final sorted = List<FaqItem>.from(_allFaqs)
      ..sort((a, b) => b.popularity.compareTo(a.popularity));
    return sorted.take(limit).toList();
  }

  List<FaqItem> getFaqsByCategory(String category) {
    return _categoryIndex[category] ?? [];
  }

  List<String> getCategories() {
    return _categoryIndex.keys.toList()..sort();
  }

  FaqItem? getFaqById(String id) {
    return _idIndex[id];
  }

  List<FaqItem> getRelatedFaqs(String faqId, {int limit = 3}) {
    final faq = _idIndex[faqId];
    if (faq == null) return [];

    final related = <FaqItem>[];
    for (final relatedId in faq.relatedQuestionIds) {
      final relatedFaq = _idIndex[relatedId];
      if (relatedFaq != null) {
        related.add(relatedFaq);
      }
    }

    return related.take(limit).toList();
  }
}
