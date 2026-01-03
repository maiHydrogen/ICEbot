import '../models/faq_item.dart';

abstract class FaqRepository {
  Future<List<FaqItem>> loadFaqs();
  Future<void> refresh();
}
