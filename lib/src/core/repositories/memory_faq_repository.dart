import '../models/faq_item.dart';
import 'faq_repository.dart';

class MemoryFaqRepository implements FaqRepository {
  final List<FaqItem> faqs;

  MemoryFaqRepository(this.faqs);

  @override
  Future<List<FaqItem>> loadFaqs() async {
    return faqs;
  }

  @override
  Future<void> refresh() async {
    // No-op for in-memory repository
  }
}
