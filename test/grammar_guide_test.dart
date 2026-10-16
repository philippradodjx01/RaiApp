import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';

void main() {
  testWidgets('guided samples reveal steps, retry mistakes and finish all five', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GrammarGuideScreen()));
    Future<void> tap(String label) async {
      final target = find.text(label);
      if (target.evaluate().isEmpty) await tester.scrollUntilVisible(target, 200);
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    for (var i = 0; i < grammarGuideItems.length; i++) {
      final item = grammarGuideItems[i];
      expect(find.text(item.hint), findsOneWidget);
      expect(find.text(item.example), findsNothing);
      await tap('Continue to Prompt');
      expect(find.text(item.prompt), findsOneWidget);
      await tap('Reveal example');
      expect(find.text(item.example), findsOneWidget);
      await tap('Continue to Reflection');
      expect(find.text(item.reflection), findsOneWidget);
      await tap('Continue to Retry');
      await tester.scrollUntilVisible(find.text('Check answer'), 200);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Check answer')).onPressed, isNull);
      if (i == 0) {
        await tap(item.choices[1]);
        await tap('Check answer');
        expect(find.textContaining('Not quite.'), findsOneWidget);
        expect(find.text('Next sample'), findsNothing);
        await tap('Try again');
      }
      await tap(item.choices[item.answer]);
      await tap('Check answer');
      expect(find.text('Correct! ${item.feedback}'), findsOneWidget);
      await tap(i == 4 ? 'Finish practice' : 'Next sample');
    }
    expect(find.text('All 5 samples completed'), findsOneWidget);
    await tap('Practice again');
    expect(find.text('Sample 1 of 5 · Nouns'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
