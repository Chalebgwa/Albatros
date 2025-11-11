import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:albatros/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlbatrosApp());

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom navigation should have 4 items', (WidgetTester tester) async {
    await tester.pumpWidget(const AlbatrosApp());
    await tester.pumpAndSettle();

    // Find navigation items
    expect(find.text('AR Scan'), findsOneWidget);
    expect(find.text('Missions'), findsOneWidget);
    expect(find.text('Badges'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
