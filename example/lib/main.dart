import 'package:flutter/material.dart';
import 'package:icebot/icebot.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> _messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICEbot FAQ Demo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE1C22)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICEcard App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'images/logo1.png',
                package: 'icebot', // Specify package name
              ),
              height: 164,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to ICEcard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap the support button for help',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FaqFloatingButton.fromAsset(
        icon: const Image(
          image: AssetImage('images/plus.png', package: 'icebot'),
          height: 32,
        ),
        assetPath: 'assets/faqs.json',
        config: IcebotConfig(
          botName: 'ICEbot',
          welcomeMessage:
              'Hello! I\'m ICEbot, your ICEcard assistant. '
              'How can I help you today?',
          noAnswerMessage:
              'I\'m sorry, I don\'t have an answer for that. '
              'Please contact our support team at support@icecard.com',
          maxSuggestions: 3,
          showTimestamp: false,
          onEscalateToSupport: () {
            _messengerKey.currentState
              ?..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Connecting you to support@icecard.com…'),
                ),
              );
          },
        ),
        theme: ChatTheme(
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
