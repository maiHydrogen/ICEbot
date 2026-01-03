import '../models/faq_item.dart';
import 'string_matcher.dart';

class SearchResult {
  final FaqItem faq;
  final double score;

  const SearchResult(this.faq, this.score);
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
    final queryNormalized = StringMatcher.normalize(query);
    final queryTokens = StringMatcher.tokenize(query);

    for (final faq in candidates) {
      double score = 0.0;

      // Exact keyword match (highest priority)
      if (_hasExactKeywordMatch(faq, queryNormalized)) {
        score = 1.0;
      }
      // Alternative question match
      else if (_matchesAlternativeQuestion(faq, queryNormalized)) {
        score = 0.95;
      }
      // Token overlap in question
      else if (_hasTokenOverlap(faq, queryTokens)) {
        score = 0.7 + (_calculateTokenOverlapScore(faq, queryTokens) * 0.2);
      }
      // Fuzzy match on question
      else {
        final similarity = StringMatcher.calculateSimilarity(
          queryNormalized,
          StringMatcher.normalize(faq.question),
        );
        if (similarity >= threshold) {
          score = similarity * 0.6;
        }
      }

      if (score > 0) {
        results.add(SearchResult(faq, score));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(maxResults).map((r) => r.faq).toList();
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

  bool _hasExactKeywordMatch(FaqItem faq, String query) {
    return faq.keywords.any((kw) => query.contains(kw.toLowerCase()));
  }

  bool _matchesAlternativeQuestion(FaqItem faq, String query) {
    return faq.alternativeQuestions.any(
          (alt) => StringMatcher.normalize(alt).contains(query) ||
          query.contains(StringMatcher.normalize(alt)),
    );
  }

  bool _hasTokenOverlap(FaqItem faq, List<String> queryTokens) {
    final questionTokens = StringMatcher.tokenize(faq.question);
    return queryTokens.any((qt) => questionTokens.contains(qt));
  }

  double _calculateTokenOverlapScore(FaqItem faq, List<String> queryTokens) {
    final questionTokens = StringMatcher.tokenize(faq.question);
    final overlap = queryTokens.where((qt) => questionTokens.contains(qt)).length;
    return overlap / queryTokens.length;
  }
}
