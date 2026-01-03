import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/faq_item.dart';
import 'faq_repository.dart';

class AssetFaqRepository implements FaqRepository {
  final String assetPath;
  List<FaqItem>? _cachedFaqs;

  AssetFaqRepository(this.assetPath);

  @override
  Future<List<FaqItem>> loadFaqs() async {
    if (_cachedFaqs != null) {
      return _cachedFaqs!;
    }

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      if (jsonData['faqs'] is! List) {
        throw FormatException('Invalid FAQ JSON: expected "faqs" array');
      }

      _cachedFaqs = (jsonData['faqs'] as List)
          .map((json) => FaqItem.fromJson(json as Map<String, dynamic>))
          .toList();

      return _cachedFaqs!;
    } catch (e) {
      throw Exception('Failed to load FAQs from asset: $e');
    }
  }

  @override
  Future<void> refresh() async {
    _cachedFaqs = null;
    await loadFaqs();
  }
}
