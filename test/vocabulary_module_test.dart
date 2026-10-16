import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold_eng_mobile/main.dart';
import 'package:scaffold_eng_mobile/services/api_service.dart';

class VocabularyTestApi extends ApiService {
  final calls = <String>[];
  @override
  Future<dynamic> get(String path) async {
    if (path.endsWith('/categories')) {
      return [
      {'id': 1, 'name': 'Word Meaning', 'description': 'Words in context'},
    ];
    }
    if (path.endsWith('/progress')) {
      return {
      'total_lessons': 30, 'completed_lessons': 3, 'quizzes_completed': 2,
      'average_score': 80, 'highest_score': 90, 'learned_words': ['abundant'],
      'word_of_day': {'word': 'abundant', 'meaning': 'Existing in large quantities.', 'part_of_speech': 'adjective'},
      'mastery': <String,dynamic>{}, 'incorrect_words': [], 'attempts': [],
    };
    }
    if (path.endsWith('/practice')) {
      return [
      {'id': 1, 'prompt': 'Choose the meaning of abundant.', 'type': 'multiple_choice', 'options': [{'body': 'Plentiful'}, {'body': 'Scarce'}, {'body': 'Small'}, {'body': 'Empty'}]},
    ];
    }
    throw Exception('Unexpected GET $path');
  }
  @override
  Future<dynamic> post(String path, [Map<String,dynamic> body=const {}]) async {
    calls.add(path);
    return {'correct': true, 'answer': 'Plentiful', 'explanation': 'Abundant means plentiful.'};
  }
  @override
  Future<dynamic> put(String path, [Map<String,dynamic> body=const {}]) async { calls.add(path); return null; }
}

void main() {
  testWidgets('dashboard displays saved progress and daily word', (tester) async {
    await tester.pumpWidget(MaterialApp(home: VocabularyDashboard(api: VocabularyTestApi())));
    await tester.pumpAndSettle();
    expect(find.text('3 / 30 lessons completed'), findsOneWidget);
    expect(find.text('abundant'), findsOneWidget);
    expect(find.text('Word Meaning'), findsOneWidget);
  });
  testWidgets('practice requires an answer and displays backend feedback', (tester) async {
    final api=VocabularyTestApi();
    await tester.pumpWidget(MaterialApp(home: VocabularyActivityScreen(api:api,lessonId:1)));
    await tester.pumpAndSettle();
    expect(find.text('Abundant means plentiful.'),findsNothing);
    await tester.tap(find.text('Plentiful'));
    await tester.pump();
    await tester.tap(find.text('Check Answer'));
    await tester.pumpAndSettle();
    expect(api.calls,contains('/vocabulary/practice/1/check'));
    expect(find.text('Abundant means plentiful.'),findsOneWidget);
  });
  testWidgets('graded quiz saves choices and hides practice feedback', (tester) async {
    final api=VocabularyTestApi();
    await tester.pumpWidget(MaterialApp(home:VocabularyActivityScreen(api:api,attemptData:const {
      'attempt':{'id':12,'expires_at':null},
      'questions':[{'id':5,'prompt':'Choose the meaning.','type':'multiple_choice','options':['Plentiful','Scarce','Small','Empty']}],
    })));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plentiful'));
    await tester.pumpAndSettle();
    expect(api.calls,contains('/vocabulary/attempts/12/answers'));
    expect(find.text('Check Answer'),findsNothing);
    expect(find.text('Correct!'),findsNothing);
    expect(find.text('Submit Test'),findsOneWidget);
  });
}
