import 'package:flutter/foundation.dart';

@immutable
class FaqItem {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final List<String> alternativeQuestions;
  final String? category;
  final int popularity;
  final bool isPinned;
  final List<String> relatedQuestionIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.keywords = const [],
    this.alternativeQuestions = const [],
    this.category,
    this.popularity = 0,
    this.isPinned = false,
    this.relatedQuestionIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      alternativeQuestions: (json['alternativeQuestions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      category: json['category']?.toString(),
      popularity: json['popularity'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      relatedQuestionIds: (json['relatedQuestionIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'keywords': keywords,
      'alternativeQuestions': alternativeQuestions,
      if (category != null) 'category': category,
      'popularity': popularity,
      'isPinned': isPinned,
      'relatedQuestionIds': relatedQuestionIds,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FaqItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
