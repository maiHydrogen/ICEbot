import 'package:icebot/index.dart';
import 'package:string_similarity/string_similarity.dart';

class FAQService {
  final List<FAQItem> _faqs;

  FAQService(this._faqs);

  List<FAQItem> searchFAQs(String query) {
    if (query.trim().isEmpty) return [];

    final results = <FAQItem>[];
    final queryLower = query.toLowerCase();

    // Exact keyword matches first
    for (final faq in _faqs) {
      if (_hasExactKeywordMatch(faq, queryLower)) {
        results.add(faq);
      }
    }

    // Partial matches
    if (results.isEmpty) {
      for (final faq in _faqs) {
        if (_hasPartialMatch(faq, queryLower)) {
          results.add(faq);
        }
      }
    }

    return results;
  }

  bool _hasExactKeywordMatch(FAQItem faq, String query) {
    return faq.keywords.any((keyword) => 
        query.contains(keyword.toLowerCase()));
  }

  bool _hasPartialMatch(FAQItem faq, String query) {
    final similarity = StringSimilarity.compareTwoStrings(
      query, 
      faq.question.toLowerCase()
    );
    return similarity > 0.6;
  }

  List<FAQItem> getSuggestions(int limit) {
    return _faqs.take(limit).toList();
  }
}
  