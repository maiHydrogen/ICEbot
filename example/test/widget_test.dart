import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('home screen renders with the FAQ button', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to ICEcard'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
