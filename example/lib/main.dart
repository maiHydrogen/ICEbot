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

  // Flag to prevent multiple modal calls
  bool _isModalShown = false;

  @override
  void initState() {
    super.initState();
    // Remove the automatic modal show - let user trigger it manually
  }

  // Fixed function signature and implementation
  void _showChatbot() {
    // Prevent multiple modals if one is already shown
    if (_isModalShown) return;

    setState(() {
      _isModalShown = true;
    });

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Allow full screen if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return ChatbotWidget(
              faqs: _faqs,
              config: const ChatbotConfig(
                botName: 'Help Assistant',
                primaryColor: Colors.blue,
                enableSuggestions: true,
                showTimestamp: true,
                maxSuggestions: 3,
              ),
              height: double.infinity,
            );
          },
        );
      },
    ).whenComplete(() {
      // Reset flag when modal is dismissed
      if (mounted) {
        setState(() {
          _isModalShown = false;
        });
      }
    });
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
                  'images/logo2.png',
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
        onPressed: _showChatbot, // Fixed: pass function reference, not call it
        tooltip: 'Open Chatbot',
        child:  Image(
          image: AssetImage(
            'images/logo2.png',
            package: 'icebot',
          ),
          height: 32,
        ),
      ),
    );
  }
}
