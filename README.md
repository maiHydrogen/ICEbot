# ICEbot FAQ - Flutter Package

A production-ready, intelligent FAQ chatbot package for Flutter applications with advanced search capabilities and beautiful Material Design UI.

## Features

- **Smart Search**: Multi-strategy matching (exact keywords, fuzzy matching, token overlap, alternative questions) with configurable similarity thresholds
- **Beautiful UI**: Material Design chat interface with typing indicators, message bubbles, and smooth animations
- **Fully Customizable**: Theme-able UI components and configurable bot behavior
- **Production Ready**: No global singletons, proper state management, null-safe, and testable architecture
- **Flexible Data Sources**: Load FAQs from JSON assets, in-memory lists, or easily extend for remote sources
- **Rich FAQ Model**: Support for categories, pinned FAQs, popularity, related questions, and alternative phrasings
- **Contextual Suggestions**: Dynamic suggestion chips based on pinned/trending FAQs and conversation context
- **Accessible**: Semantic labels, keyboard navigation, and copy-to-clipboard support


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

Create `assets/faqs.json` matching the `FaqItem` schema:

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

For full control over the chatbot lifecycle and state:

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

