import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';
import 'package:scaffold_eng_mobile/services/api_service.dart';

class CurriculumApi extends ApiService {
  final List lessons;
  CurriculumApi(this.lessons);

  @override
  Future<dynamic> get(String path) async => lessons;
}

void main() {
  final curriculum = jsonDecode(File('../database/seeders/data/grammar-curriculum.json').readAsStringSync()) as List;

  test('curriculum has six categories, 21 distinct lessons and valid assessments', () {
    expect(curriculum.length, 21);
    expect(curriculum.map((e) => e['category']).toSet().length, 6);
    expect(curriculum.map((e) => e['title']).toSet().length, 21);
    for (final lesson in curriculum) {
      for (final section in ['objectives', 'introduction', 'definition', 'classifications', 'rules', 'examples', 'mistakes', 'practice', 'answers', 'takeaways']) {
        expect((lesson[section] as String).length, greaterThan(30), reason: '${lesson['title']}: $section');
      }
      expect(lesson['assessment'], hasLength(2));
      for (final question in lesson['assessment']) {
        expect(question['options'], hasLength(4));
        expect((question['options'] as List).toSet(), hasLength(4));
        expect(question['correct'], inInclusiveRange(0, 3));
        expect(question['explanation'], isNotEmpty);
      }
    }
  });

  testWidgets('grammar categories filter lessons and open structured content', (tester) async {
    final lessons = [
      for (var i = 0; i < curriculum.length; i++)
        {
          'id': i + 1,
          'title': curriculum[i]['title'],
          'category': 'grammar',
          'grammar_category': curriculum[i]['category'],
          'grammar_order': i + 1,
          'duration_minutes': 10,
          'content': curriculum[i]['introduction'],
          'grammar_topics': [
            {'title': 'Grammar rules', 'explanation': curriculum[i]['rules'], 'examples': []},
          ],
        },
    ];
    await tester.pumpWidget(MaterialApp(home: LessonsScreen(api: CurriculumApi(lessons), category: 'grammar')));
    await tester.pumpAndSettle();
    final filter = find.widgetWithText(ChoiceChip, 'Punctuation');
    await tester.scrollUntilVisible(filter, 200);
    await tester.tap(filter);
    await tester.pumpAndSettle();
    expect(find.text('Nouns'), findsNothing);
    await tester.scrollUntilVisible(find.text('Commas'), 200);
    await tester.tap(find.text('Commas'));
    await tester.pumpAndSettle();
    final start = find.widgetWithText(OutlinedButton, 'Start Lesson');
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();
    expect(find.text('Punctuation · 10 min'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('2. Grammar rules'), 200);
    await tester.tap(find.text('2. Grammar rules'));
    await tester.pumpAndSettle();
    expect(find.text(curriculum.firstWhere((e) => e['title'] == 'Commas')['rules']), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
