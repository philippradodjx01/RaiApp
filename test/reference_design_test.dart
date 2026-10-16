import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';
import 'package:scaffold_eng_mobile/services/api_service.dart';

class DesignApi extends ApiService {
  final writes = <String>[];
  @override
  Future<dynamic> get(String path) async => switch (path) {
        '/progress' => {
            'mastery': 72,
            'today_count': 0,
            'by_category': {'grammar': 78, 'vocabulary': 85, 'reading': 80},
            'activities': <dynamic>[]
          },
        '/lessons' => [
            {
              'id': 1,
              'title': 'Nouns and Pronouns',
              'category': 'grammar',
              'duration_minutes': 10,
              'content':
                  'A noun names a person, place, thing, or idea. Pronouns take the place of nouns.'
            }
          ],
        '/journals' => {'data': <dynamic>[]},
        _ => <dynamic>[],
      };
  @override
  Future<dynamic> post(String path,
      [Map<String, dynamic> body = const {}]) async {
    writes.add(path);
    if (path == '/answers/check') {
      return {'correct': true, 'explanation': 'Dog is a noun.'};
    }
    return {};
  }
}

const sampleUser = {'name': 'Learner', 'email': 'learner@example.test'};
final sampleTest = {
  'id': 1,
  'title': 'Diagnostic test',
  'questions': [
    {
      'id': 1,
      'prompt': 'The _____ is barking loudly.',
      'options': [
        {'id': 1, 'label': 'A', 'body': 'run'},
        {'id': 2, 'label': 'B', 'body': 'quickly'},
        {'id': 3, 'label': 'C', 'body': 'dog'},
        {'id': 4, 'label': 'D', 'body': 'happily'},
      ]
    },
    {
      'id': 2,
      'prompt': 'Choose a noun.',
      'options': [
        {'id': 5, 'label': 'A', 'body': 'book'}
      ]
    },
  ]
};

void main() {
  setUpAll(() async {
    final file = File('C:/Windows/Fonts/arial.ttf');
    if (file.existsSync()) {
      for (final family in ['Roboto', 'Ahem']) {
        final loader = FontLoader(family)
          ..addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
        await loader.load();
      }
    }
    final icons = File(
        'C:/src/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (icons.existsSync()) {
      await (FontLoader('MaterialIcons')
            ..addFont(
                Future.value(ByteData.sublistView(icons.readAsBytesSync()))))
          .load();
    }
  });
  Future<void> capture(WidgetTester tester, String name) async {
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('capture')));
      final image = await boundary.toImage();
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('design-evidence')..createSync(recursive: true);
      File('${dir.path}/$name.png')
          .writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets('reference screens preserve content and core interactions',
      (tester) async {
    await tester.pumpWidget(Container());
    final api = DesignApi();
    final theme = (const ScaffoldEngApp()
            .build(tester.element(find.byType(Container))) as MaterialApp)
        .theme;
    Future<void> show(Widget page, String name,
        {double width = 393, double scale = 1}) async {
      tester.view.physicalSize = Size(width, 852);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(MaterialApp(
          key: ValueKey(name),
          theme: theme,
          home: MediaQuery(
              data: MediaQueryData(
                  size: Size(width, 852), textScaler: TextScaler.linear(scale)),
              child: RepaintBoundary(
                  key: const ValueKey('capture'), child: page))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture(tester, name);
      await tester.pump();
    }

    await show(LoginScreen(api: api, onLogin: (_) {}), 'login');
    expect(find.text('Welcome Back!'), findsOneWidget);
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your password'), findsOneWidget);
    await tester.tap(find.text('Create an Account'));
    await tester.pumpAndSettle();
    expect(find.text('Full name'), findsOneWidget);
    await show(
        LearnerShell(api: api, user: sampleUser, onLogout: () {}), 'home');
    await tester.tap(find.text('Lessons').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nouns and Pronouns'));
    await tester.pumpAndSettle();
    await capture(tester, 'lesson');
    expect(
        find.text(
            'A noun names a person, place, thing, or idea. Pronouns take the place of nouns.'),
        findsOneWidget);
    await tester.tap(find.text('Mark complete'));
    await tester.pumpAndSettle();
    expect(api.writes, contains('/lessons/1/complete'));
    await show(ProgressScreen(api: api), 'progress');
    expect(find.text('72%'), findsOneWidget);
    await show(QuizScreen(api: api, test: sampleTest), 'practice');
    await tester.tap(find.text('C. dog'));
    await tester.pumpAndSettle();
    await capture(tester, 'practice-selected');
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.text('Correct! Dog is a noun.'), findsOneWidget);
    await tester.tap(find.text('Next question'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a noun.'), findsOneWidget);
    await show(
        ProfileScreen(
            api: api, user: sampleUser, onLogout: () {}, journalOnly: true),
        'reflection');
    await tester.enterText(
        find.byType(TextField).first, 'I learned about nouns.');
    await tester.ensureVisible(find.text('Save reflection'));
    await tester.tap(find.text('Save reflection'));
    await tester.pumpAndSettle();
    expect(api.writes, contains('/journals'));
    await show(
        LessonScreen(
            api: api,
            lesson: Map<String, dynamic>.from(
                (await api.get('/lessons') as List).first)),
        'lesson-overview');
    await show(LessonsScreen(api: api, category: 'grammar'), 'grammar-module');
    await show(EngagementScreen(api: api, onJournal: () {}), 'engagement');
    await show(ProgressScreen(api: api), 'progress-small',
        width: 320, scale: 1.3);
    await show(
        LearnerShell(api: api, user: sampleUser, onLogout: () {}), 'home-small',
        width: 320, scale: 1.3);
    await show(
        LearnerShell(api: api, user: sampleUser, onLogout: () {}), 'home-desktop',
        width: 1440);
    await show(
        ProfileScreen(
            api: api, user: sampleUser, onLogout: () {}, journalOnly: true),
        'reflection-small',
        width: 320,
        scale: 1.3);
    await tester.pumpWidget(const SizedBox.shrink());
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
