# ICEbot FAQ - Flutter Package

A production-ready, intelligent FAQ chatbot package for Flutter applications with advanced search capabilities and beautiful Material Design UI.
## Getting started

<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

## Features

- **🎯 Smart Search**: Multi-strategy matching (exact keywords, fuzzy matching, token overlap, alternative questions) with configurable similarity thresholds[^9]
- **💬 Beautiful UI**: Material Design chat interface with typing indicators, message bubbles, and smooth animations[^3]
- **🎨 Fully Customizable**: Theme-able UI components and configurable bot behavior[^5]
- **📱 Production Ready**: No global singletons, proper state management, null-safe, and testable architecture[^8]
- **🔌 Flexible Data Sources**: Load FAQs from JSON assets, in-memory lists, or easily extend for remote sources[^9]
- **🏷️ Rich FAQ Model**: Support for categories, pinned FAQs, popularity, related questions, and alternative phrasings[^7]
- **📊 Contextual Suggestions**: Dynamic suggestion chips based on pinned/trending FAQs and conversation context[^11]
- **♿ Accessible**: Semantic labels, keyboard navigation, and copy-to-clipboard support


## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
flutter:
sdk: flutter
ICEbot:
git:
url: https://github.com/maiHydrogen/ICEbot.git
path: packages/icebot
ref: main
# path: ../packages/scoreboard
```

Then run:

```bash
flutter pub get
```


## Quick Start

### 1. Create FAQ JSON File

Create `assets/faqs.json` matching the `FaqItem` schema:[^7]

```json
{
  "faqs": [
    {
      "id": "1",
      "question": "How do I reset my password?",
      "answer": "Go to Settings > Security > Change Password. You'll receive a verification email.",
      "keywords": ["password", "reset", "forgot", "change"],
      "alternativeQuestions": ["Forgot password", "Can't log in"],
      "category": "Account",
      "popularity": 100,
      "isPinned": true,
      "relatedQuestionIds": ["2", "3"]
    }
  ]
}
```


### 2. Register Asset

Add to your app's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/faqs.json
```


### 3. Add Floating Button

```dart
import 'package:icebot_faq/icebot_faq.dart';

Scaffold(
  appBar: AppBar(title: Text('My App')),
  body: YourContent(),
  floatingActionButton: FaqFloatingButton.fromAsset(
    assetPath: 'assets/faqs.json',
  ),
)
```

That's it! The chatbot is now integrated with zero configuration.

## Usage Examples

### Basic Usage with Custom Config

```dart
FaqFloatingButton.fromAsset(
  assetPath: 'assets/faqs.json',
  config: IcebotConfig(
    botName: 'ICEbot',
    welcomeMessage: 'Hello! How can I help you today?',
    noAnswerMessage: 'I couldn\'t find an answer. Contact support@example.com',
    typingDelay: Duration(milliseconds: 500),
    maxSuggestions: 3,
    matchThreshold: 0.3,
    showTimestamp: false,
  ),
)
```


### Custom Theme

```dart
FaqFloatingButton.fromAsset(
  assetPath: 'assets/faqs.json',
  theme: ChatTheme(
    primaryColor: Color(0xFFEE1C22),
    secondaryColor: Color(0xFF730F11),
    userBubbleColor: Colors.white,
    botBubbleColor: Color(0xFFF5F5F5),
    borderRadius: 16.0,
  ),
)
```


### From In-Memory FAQ List

```dart
final faqs = [
  FaqItem(
    id: '1',
    question: 'How do I activate my card?',
    answer: 'Download the app and follow activation steps.',
    keywords: ['activate', 'enable'],
    category: 'Getting Started',
    isPinned: true,
  ),
];

FaqFloatingButton.fromFaqList(
  faqs: faqs,
  config: IcebotConfig(botName: 'MyBot'),
)
```


### Advanced: Custom Controller

For full control over the chatbot lifecycle and state:[^3]

```dart
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FaqChatController _controller;

  @override
  void initState() {
    super.initState();
    final repository = AssetFaqRepository('assets/faqs.json');
    _controller = FaqChatController(
      repository: repository,
      config: IcebotConfig(),
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FaqFloatingButton(
        controller: _controller,
      ),
    );
  }
}
```


## FAQ JSON Schema

The package uses a structured JSON format based on the `FaqItem` model:[^7]


| Field | Type | Required | Description |
| :-- | :-- | :-- | :-- |
| `id` | String | Yes | Unique identifier |
| `question` | String | Yes | The FAQ question |
| `answer` | String | Yes | The answer text |
| `keywords` | String[] | No | Keywords for exact matching |
| `alternativeQuestions` | String[] | No | Alternative phrasings |
| `category` | String | No | Category name for grouping |
| `popularity` | Number | No | Popularity score (for trending) |
| `isPinned` | Boolean | No | Show as suggestion (default: false) |
| `relatedQuestionIds` | String[] | No | IDs of related FAQs |
| `createdAt` | ISO String | No | Creation timestamp |
| `updatedAt` | ISO String | No | Last update timestamp |

## Configuration Options

### IcebotConfig

```dart
IcebotConfig(
  botName: 'ICEbot',                    // Display name
  welcomeMessage: 'Hello!',             // Initial greeting
  noAnswerMessage: 'Contact support',   // Fallback message
  typingDelay: Duration(milliseconds: 500), // Bot response delay
  maxSuggestions: 3,                    // Suggestion chips count
  matchThreshold: 0.3,                  // Fuzzy match threshold (0.0-1.0)
  showTimestamp: false,                 // Show message timestamps
  onEscalateToSupport: () {},          // Custom support callback
)
```


### ChatTheme

```dart
ChatTheme(
  primaryColor: Color,        // Header & send button
  secondaryColor: Color,      // Accent elements
  userBubbleColor: Color,     // User message background
  botBubbleColor: Color,      // Bot message background
  backgroundColor: Color,      // Screen background
  userTextStyle: TextStyle,   // User message text
  botTextStyle: TextStyle,    // Bot message text
  timestampStyle: TextStyle,  // Timestamp text
  borderRadius: 16.0,         // Bubble corner radius
  bubbleElevation: 0.0,       // Bubble shadow elevation
)
```


## Search Algorithm

The search engine uses a multi-tier matching strategy with prioritized scoring:[^9]

1. **Exact Keyword Match (score: 1.0)**: Query contains FAQ keywords
2. **Alternative Question Match (score: 0.95)**: Matches alternative phrasings
3. **Token Overlap (score: 0.7-0.9)**: Common words in question
4. **Fuzzy Similarity (score: threshold-0.6)**: Levenshtein distance-based matching

Results are sorted by score and limited by `maxResults`.

## Updating FAQs

### Asset-Based (Recommended for ICEcard)

1. Edit `assets/faqs.json` in your app
2. Rebuild and release the app
3. No code changes required

### Future: Remote FAQs

To enable remote updates without app releases, implement `FaqRepository`:

```dart
class RemoteFaqRepository implements FaqRepository {
  final String url;
  
  RemoteFaqRepository(this.url);
  
  @override
  Future<List<FaqItem>> loadFaqs() async {
    // Fetch from API, cache locally, handle errors
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    return (json['faqs'] as List)
        .map((e) => FaqItem.fromJson(e))
        .toList();
  }
}
```


## Architecture Overview

```
┌─────────────────────────────────────────┐
│            UI Layer                     │
│  FaqFloatingButton → FaqChatScreen      │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Controller Layer                │
│       FaqChatController                 │
│  (State Management & Logic)             │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Service Layer                   │
│  FaqSearchEngine (Matching & Ranking)   │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│       Repository Layer                  │
│  AssetFaqRepository | MemoryFaqRepo     │
└─────────────────────────────────────────┘
```

**No global singletons** - each controller instance is independent.[^8]

## Best Practices

1. **Keywords Matter**: Add comprehensive keywords to improve exact matching[^9]
2. **Alternative Questions**: Include common phrasings users might type[^7]
3. **Pin Important FAQs**: Use `isPinned: true` for critical questions[^11]
4. **Categories**: Group related FAQs for better organization
5. **Related Questions**: Link FAQs to guide users through topics[^9]
6. **Popularity Scores**: Higher scores appear in trending suggestions[^11]


## Roadmap
these are future feats to be integrated in package -

- [ ] Remote FAQ repository with caching
- [ ] Analytics tracking (search queries, suggestion clicks)
- [ ] Multi-language support
- [ ] Rich text answers (Markdown/HTML)
- [ ] File attachments in answers
- [ ] Voice input support
- [ ] Admin dashboard for FAQ management


## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes with clear messages
4. Write/update tests for new features
5. Ensure `flutter analyze` passes with no warnings
6. Submit a Pull Request

## License

MIT License - see LICENSE file for details

***

**Built with ❤️ for ICEcard by the ICEcard Team**
<span style="display:none">[^1][^10][^2][^4][^6]</span>

<div align="center">⁂</div>

[^1]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/962be7d2-504e-4372-b013-90e3a80035e7/chat_services.dart

[^2]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/83fb42f9-3b4b-47da-a73e-fe0283473f71/chat_message.dart

[^3]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/8d0f6046-ffc2-463c-86a5-4edf913e8acb/chatbot_widget.dart

[^4]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/ecb720fc-7c20-48f8-86a1-c9a98bebb38f/index.dart

[^5]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/0ec2ae7c-71d7-4b8e-8068-3b6f91a8b553/chatbot_config.dart

[^6]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/4ddd3c30-80c6-4a52-ad63-4e9815f961df/chat_bubble.dart

[^7]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/2a3f90a8-150c-481b-bb04-5a37fc987f78/faq_items.dart

[^8]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/b1381c91-06e4-43cd-81b7-602d8cd7f21b/faq_loader.dart

[^9]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/c371dbb8-f90c-4a1d-82e2-e6375cf40b72/improved_faq_manager.dart

[^10]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/d4ce67b8-1e4e-4750-bf03-146c2aef8ad3/faqs.json

[^11]: https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/72234751/61a28d84-9a29-4056-91ec-6365ec71d106/faq_services.dart

