import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';
import 'learning_flow_test.dart' as fixtures;

void main() {
  testWidgets('floating navigation switches tabs and opens diagnostic test', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: LearnerShell(
      api: fixtures.FlowApi(), user: fixtures.learner, onLogout: () {},
    )));
    await tester.pumpAndSettle();
    for (final destination in [('Lessons', LessonsScreen), ('Progress', ProgressScreen), ('Profile', ProfileScreen), ('Home', HomeScreen)]) {
      await tester.tap(find.byTooltip(destination.$1));
      await tester.pumpAndSettle();
      expect(find.byType(destination.$2), findsOneWidget);
    }
    await tester.tap(find.byTooltip('Start diagnostic test'));
    await tester.pumpAndSettle();
    expect(find.byType(DiagnosticScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final width in [320.0, 393.0, 768.0, 1440.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('dashboard fits width $width with text scale $scale',
          (tester) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale), disableAnimations: true),
            child:
                Directionality(textDirection: TextDirection.rtl, child: child!),
          ),
          home: LearnerShell(
              api: fixtures.FlowApi(), user: fixtures.learner, onLogout: () {}),
        ));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(find.text('Continue learning'), 250,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(NavigationRail),
            width >= 1000 && scale == 1 ? findsOneWidget : findsNothing);
      });
    }
  }

  testWidgets('dashboard actions open their learning destinations',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = fixtures.FlowApi();
    var selected = '';
    Future<void> show() async {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: HomeScreen(
        api: api,
        user: fixtures.learner,
        onLessons: () => selected = 'lessons',
        onProgress: () => selected = 'progress',
        onJournal: () => selected = 'profile',
      ))));
      await tester.pumpAndSettle();
    }

    for (final action in ['Lesson', 'All lessons', 'See all', 'My Progress']) {
      await show();
      await tester.ensureVisible(find.text(action));
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(selected, action == 'My Progress' ? 'progress' : 'lessons');
    }
    await show();
    await tester.tap(find.byTooltip('Your profile'));
    expect(selected, 'profile');
    for (final category in ['Grammar', 'Vocabulary', 'Reading']) {
      await show();
      await tester.tap(find.text(category));
      await tester.pumpAndSettle();
      expect(find.byType(LessonsScreen), findsOneWidget);
      expect(tester.widget<LessonsScreen>(find.byType(LessonsScreen)).category,
          category.toLowerCase());
    }
    await show();
    await tester.tap(find.text('Diagnostic Test'));
    await tester.pumpAndSettle();
    expect(find.byType(DiagnosticScreen), findsOneWidget);
    await show();
    await tester.tap(find.text('Engagement'));
    await tester.pumpAndSettle();
    expect(find.byType(EngagementScreen), findsOneWidget);
    await show();
    await tester.tap(find.text('Reflect'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(tester.widget<ProfileScreen>(find.byType(ProfileScreen)).journalOnly,
        isTrue);
    expect(tester.takeException(), isNull);
  });
}
