import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';
import 'package:scaffold_eng_mobile/services/api_service.dart';

const learner = {'name': 'Learner', 'email': 'learner@example.test'};
final question = {
  'id': 9,
  'prompt': 'Choose the noun.',
  'options': [
    {'id': 91, 'label': 'A', 'body': 'book'}
  ]
};
final lessons = [
  {
    'id': 1,
    'title': 'Nouns and Pronouns',
    'category': 'grammar',
    'content': 'A noun names a person, place or thing.',
    'description': 'Learn to use nouns and pronouns correctly.',
    'duration_minutes': 10,
    'grammar_topics': [
      {
        'title': 'What is a Noun?',
        'explanation': 'Name a thing.',
        'examples': ['A book.']
      }
    ],
    'questions': [question]
  },
  {
    'id': 2,
    'title': 'Academic Words',
    'category': 'vocabulary',
    'content': 'Learn a word in context.',
    'duration_minutes': 5,
    'vocabulary_words': [
      {
        'word': 'curious',
        'meaning': 'Eager to learn.',
        'synonyms': ['inquisitive'],
        'antonyms': ['uninterested']
      }
    ]
  },
  {
    'id': 3,
    'title': 'Main Ideas',
    'category': 'reading',
    'content': 'Read a short passage.',
    'duration_minutes': 6
  },
];

class FlowApi extends ApiService {
  final writes = <(String, Map<String, dynamic>)>[];
  bool failSubmission = false;
  Completer<dynamic>? pendingCheck;
  @override
  Future<dynamic> get(String path) async => switch (path) {
        '/lessons' => lessons,
        '/progress' => {
            'mastery': 72,
            'today_count': 3,
            'by_category': {'grammar': 45, 'vocabulary': 85},
            'activities': [],
            'recommendations': [lessons.first],
            'achievements': [
              {
                'achievement': {
                  'name': 'First steps',
                  'description': 'Complete an activity.'
                }
              }
            ]
          },
        '/journals' => {'data': []},
        '/diagnostics' => [
            {
              'id': 5,
              'title': 'English check-in',
              'questions': [question]
            }
          ],
        _ => throw StateError('Unexpected route: $path'),
      };
  @override
  Future<dynamic> post(String path,
      [Map<String, dynamic> body = const {}]) async {
    writes.add((path, Map.of(body)));
    if (path == '/answers/check') {
      return pendingCheck == null
          ? {'correct': true, 'explanation': 'Book is a noun.'}
          : pendingCheck!.future;
    }
    if (path == '/answers/submit') {
      if (failSubmission) throw ApiException('Try saving again.');
      return {'score': 1, 'total': 1, 'percentage': 100};
    }
    return {};
  }
}

void main() {
  Future<void> show(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pumpAndSettle();
  }

  testWidgets('category cards open only their own lessons', (tester) async {
    final api = FlowApi();
    await show(tester, LearnerShell(api: api, user: learner, onLogout: () {}));
    await tester.tap(find.text('Vocabulary'));
    await tester.pumpAndSettle();
    expect(find.text('Academic Words'), findsOneWidget);
    expect(find.text('Nouns and Pronouns'), findsNothing);
    expect(find.text('Main Ideas'), findsNothing);
    expect(find.text('Synonyms and Antonyms'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('continue learning opens a lesson with working completion',
      (tester) async {
    final api = FlowApi();
    await show(tester, Scaffold(body: LessonFeed(api: api)));
    await tester.tap(find.text('Nouns and Pronouns'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Lesson'));
    await tester.pumpAndSettle();
    expect(find.text('A noun names a person, place or thing.'), findsOneWidget);
    await tester.tap(find.text('Mark complete'));
    await tester.pumpAndSettle();
    expect(api.writes.where((write) => write.$1 == '/lessons/1/complete'),
        hasLength(1));
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets(
      'lesson practice saves its skill and can retry without duplicate answers',
      (tester) async {
    final api = FlowApi()..failSubmission = true;
    await show(tester, LessonScreen(api: api, lesson: lessons.first));
    await tester.ensureVisible(find.text('Practice and Application'));
    await tester.tap(find.text('Practice and Application'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A. book'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish check-in'));
    await tester.pumpAndSettle();
    expect(find.text('Try saving again.'), findsOneWidget);
    api.failSubmission = false;
    await tester.tap(find.text('Finish check-in'));
    await tester.pumpAndSettle();
    final submissions =
        api.writes.where((write) => write.$1 == '/answers/submit').toList();
    expect(submissions, hasLength(2));
    expect(submissions.last.$2['category'], 'grammar');
    expect(submissions.last.$2.containsKey('diagnostic_test_id'), isFalse);
    expect(submissions.last.$2['answers'], hasLength(1));
    expect(find.text('Check-in complete'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Nouns and Pronouns'), findsOneWidget);
  });

  testWidgets('diagnostics retain their assessment ID', (tester) async {
    final api = FlowApi();
    await show(tester, DiagnosticScreen(api: api));
    await tester.tap(find.text('Start Diagnostic Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A. book'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish check-in'));
    await tester.pumpAndSettle();
    expect(api.writes.last.$2['diagnostic_test_id'], 5);
    expect(api.writes.last.$2['category'], 'diagnostic');
  });

  testWidgets(
      'progress tabs show measured scores and unassessed skills honestly',
      (tester) async {
    await show(tester, ProgressScreen(api: FlowApi()));
    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Vocabulary (85%)'), findsOneWidget);
    expect(find.text('Grammar (45%)'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Grammar'));
    await tester.pumpAndSettle();
    expect(find.text('45%'), findsWidgets);
    expect(find.text('Vocabulary (85%)'), findsNothing);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Reading'));
    await tester.pumpAndSettle();
    expect(find.text('—'), findsOneWidget);
    expect(find.text('Not assessed'), findsOneWidget);
  });

  testWidgets('journal saves mood, text, date and goal using the existing API',
      (tester) async {
    final api = FlowApi();
    await show(
        tester,
        ProfileScreen(
            api: api, user: learner, onLogout: () {}, journalOnly: true));
    await tester.tap(find.text('Difficult'));
    await tester.enterText(
        find.byType(TextField).first, 'I practiced pronouns.');
    await tester.enterText(find.byType(TextField).last, 'Read tomorrow.');
    await tester.tap(find.text('Save reflection'));
    await tester.pumpAndSettle();
    final saved = api.writes.single;
    expect(saved.$1, '/journals');
    expect(saved.$2['mood'], 'challenging');
    expect(saved.$2['learned'], 'I practiced pronouns.');
    expect(saved.$2['next_goal'], 'Read tomorrow.');
    expect(saved.$2['entry_date'],
        DateTime.now().toIso8601String().substring(0, 10));
  });

  testWidgets('engagement shows earned badges and opens the journal',
      (tester) async {
    var opened = false;
    await show(tester,
        EngagementScreen(api: FlowApi(), onJournal: () => opened = true));
    await tester.ensureVisible(find.text('First steps'));
    expect(find.text('First steps'), findsOneWidget);
    await tester.ensureVisible(find.text('Reflection Journal'));
    await tester.tap(find.text('Reflection Journal'));
    expect(opened, isTrue);
  });

  testWidgets(
      'leaving a quiz during answer checking does not update disposed state',
      (tester) async {
    final api = FlowApi()..pendingCheck = Completer<dynamic>();
    await show(
        tester,
        QuizScreen(api: api, test: {
          'questions': [question]
        }));
    await tester.tap(find.text('A. book'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    api.pendingCheck!
        .complete({'correct': true, 'explanation': 'Book is a noun.'});
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
