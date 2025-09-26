import 'package:flutter/material.dart';
import 'package:icebot/icebot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final faqs = [
      FAQItem(
        id: '1',
        question: 'How do I reset my password?',
        answer: 'Go to Settings > Account > Reset Password.',
        keywords: ['password', 'reset', 'forgot'],
      ),
      // Add more FAQs...
    ];

    return MaterialApp(
      title: 'FAQ Chatbot Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Chatbot Package Demo')),
        body: ChatbotWidget(
          faqs: faqs,
          config: ChatbotConfig(
            botName: 'Help Assistant',
            primaryColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
