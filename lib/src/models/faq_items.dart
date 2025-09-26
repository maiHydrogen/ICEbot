class FAQItem {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final List<String> alternativeQuestions;

  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    this.alternativeQuestions = const [],
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      keywords: List<String>.from(json['keywords']),
      alternativeQuestions: List<String>.from(json['alternativeQuestions'] ?? []),
    );
  }
}
