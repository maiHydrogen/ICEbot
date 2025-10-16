import 'package:flutter/material.dart';
import 'package:icebot/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(1, 238, 28, 34),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Move FAQs to class level to avoid recreating on every build
  static const List<FAQItem> _faqs = [
    FAQItem(
      id: '1',
      question: 'How do I reset my password?',
      answer:
          'Go to Settings > Account > Reset Password and follow the instructions.',
      keywords: ['password', 'reset', 'forgot'],
    ),
    FAQItem(
      id: '2',
      question: 'How do I contact support?',
      answer:
          'You can contact support via email at support@example.com or through the in-app chat.',
      keywords: ['support', 'contact', 'help'],
    ),
    FAQItem(
      id: '3',
      question: 'How do I update my profile?',
      answer: 'Go to Settings > Profile to update your personal information.',
      keywords: ['profile', 'update', 'settings'],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICEBot Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  'images/logo1.png',
                  package: 'icebot', // Specify package name
                ),
                height: 164,
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to ICEBot',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Tap the chat button to get started with FAQs',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatbotWidget(
                faqs: _faqs,
                config: ChatbotConfig(
                  botName: 'ICE Bot',
                  enableSuggestions: true,
                  showTimestamp: true,
                  maxSuggestions: 3,
                ),
              ),
            ),
          );
        },
        child: Image(
          image: AssetImage('images/plus.png', package: 'icebot'),
          height: 32,
        ),
      ),
    );
  }
}
