import 'package:flutter/material.dart';
import '../../core/models/faq_item.dart';
import '../theme/chat_theme.dart';

class SuggestionChips extends StatelessWidget {
  final List<FaqItem> suggestions;
  final ChatTheme theme;
  final Function(FaqItem) onSuggestionTap;

  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.theme,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ActionChip(
            label: Text(
              suggestion.question,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () => onSuggestionTap(suggestion),
            backgroundColor: theme.botBubbleColor,
            side: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
            labelStyle: TextStyle(
              color: theme.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }
}
