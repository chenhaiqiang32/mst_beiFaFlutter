// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:beifa_app_platform/main.dart';
import 'package:beifa_app_platform/services/language_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: BeifaApp is the actual main widget
    final languageService = LanguageService();
    await languageService.loadSavedLanguage();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<LanguageService>.value(
        value: languageService,
        child: const BeifaApp(),
      ),
    );

    // Just verify the app builds without errors
    expect(find.byType(BeifaApp), findsOneWidget);
  });
}
