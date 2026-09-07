## 0.0.1

Initial release.

* `FaqChatController` (`ChangeNotifier`) driving chat state, search and suggestions.
* `FaqSearchEngine` with multi-strategy matching: exact, normalized, substring,
  alternative questions, multi-keyword, token overlap and fuzzy (Levenshtein).
* Data sources: `AssetFaqRepository` (bundled JSON) and `MemoryFaqRepository`
  (in-memory list), behind the `FaqRepository` interface.
* UI: `FaqFloatingButton`, `FaqChatScreen`, `ChatBubble`, `SuggestionChips`,
  with typing indicator and copy-to-clipboard.
* `IcebotConfig` for bot behaviour and `ChatTheme` for appearance.
* Contextual suggestion chips from pinned / trending / related FAQs.
* "Contact support" escalation from unanswered questions via
  `IcebotConfig.onEscalateToSupport`.
