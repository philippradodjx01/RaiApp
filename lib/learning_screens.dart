part of 'main.dart';

String areaTitle(String value) => value.isEmpty
    ? 'Lessons'
    : '${value[0].toUpperCase()}${value.substring(1)}';

Future<void> openLesson(
        BuildContext context, ApiService api, Map<String, dynamic> lesson) =>
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => LessonScreen(api: api, lesson: lesson)));

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.api, required this.lesson});
  final ApiService api;
  final Map<String, dynamic> lesson;
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool started = false;
  bool busy = false;
  bool completed = false;
  Future<void> complete() async {
    setState(() => busy = true);
    try {
      await widget.api.post('/lessons/${widget.lesson['id']}/complete');
      if (!mounted) return;
      setState(() => completed = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lesson marked complete!')));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final category = lesson['category']?.toString() ?? 'grammar';
    final topics = List<Map<String, dynamic>>.from(
        (lesson['grammar_topics'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e)));
    final words = List<Map<String, dynamic>>.from(
        (lesson['vocabulary_words'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e)));
    final passages = lesson['reading_passages'] as List? ?? [];
    final questions = {
      for (final question in [
        ...lesson['questions'] as List? ?? [],
        ...passages.expand((passage) => passage['questions'] as List? ?? []),
      ]) question['id']: question,
    }.values.toList();
    final sections = <(String, String)>[
      if ((lesson['content'] ?? '').toString().isNotEmpty)
        (lesson['grammar_category'] != null ? 'Introduction' : '${areaTitle(category)} lesson', lesson['content'].toString()),
      ...passages.map((passage) => (passage['title'].toString(), passage['body'].toString())),
      ...topics.map((topic) => (
            topic['title'].toString(),
            [topic['explanation'], ...(topic['examples'] as List? ?? [])]
                .where((e) => e != null)
                .join('\n\n')
          )),
      ...words.where((word) => category != 'vocabulary').map((word) => (
            word['word'].toString(),
            [
              word['part_of_speech'],
              word['meaning'],
              word['example'],
              if ((word['synonyms'] as List? ?? []).isNotEmpty)
                'Synonyms: ${(word['synonyms'] as List).join(', ')}',
              if ((word['antonyms'] as List? ?? []).isNotEmpty)
                'Antonyms: ${(word['antonyms'] as List).join(', ')}'
            ].where((e) => e != null).join('\n\n')
          )),
    ];
    final lessonProgress = completed ? 1.0 : started ? .5 : 0.1;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FC),
        title: Text(areaTitle(category)),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Center(
              child: Text(
                '${completed ? sections.length : 1}/${sections.isEmpty ? 1 : sections.length}',
                style: const TextStyle(
                    color: navy, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: busy || completed
                    ? null
                    : started
                        ? complete
                        : () => setState(() => started = true),
                icon:
                    Icon(completed ? Icons.check_circle : Icons.arrow_forward),
                label: Text(busy
                    ? 'Saving...'
                    : completed
                        ? 'Completed'
                        : started
                            ? 'Mark complete'
                            : 'Start Lesson'),
              ))),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 24), children: [
                Row(children: [
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                              value: lessonProgress,
                              minHeight: 9,
                              backgroundColor: const Color(0xFFDCE8F5),
                              color: blue))),
                  const SizedBox(width: 12),
                  Text('${(lessonProgress * 100).round()}%',
                      style: const TextStyle(
                          color: navy, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 26),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEAF6FF), Color(0xFFF4F9FF)],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFD9EBFC))),
                    child: Column(children: [
                      Container(
                        width: 94,
                        height: 82,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: const Icon(Icons.menu_book_rounded,
                            size: 58, color: blue),
                      ),
                      const SizedBox(height: 17),
                      Text(lesson['title'] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: navy)),
                      if (lesson['grammar_category'] != null) ...[
                        const SizedBox(height: 10),
                        Text('${lesson['grammar_category']} · ${lesson['duration_minutes']} min',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: muted)),
                      ],
                      if (lesson['vocabulary_category'] != null) ...[
                        const SizedBox(height: 10),
                        Text('${lesson['vocabulary_category']} · ${lesson['duration_minutes']} min',
                            textAlign: TextAlign.center),
                      ],
                      if (lesson['description'] != null) ...[
                        const SizedBox(height: 10),
                        Text(lesson['description'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 17, height: 1.5, color: navy))
                      ],
                    ])),
                const SizedBox(height: 16),
                if (category == 'vocabulary') ...[
                  for (final word in words) VocabularyWordCard(word: word),
                  VocabularyPracticeCard(words: words),
                ],
                for (var i = 0; i < sections.length; i++)
                  Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Color(0xFFE5EEF8))),
                      margin: const EdgeInsets.only(bottom: 9),
                      child: ExpansionTile(
                        key: ValueKey('${started}_$i'),
                        initiallyExpanded: started && i == 0,
                        leading: LearningIcon(
                            icon: i == 0
                                ? Icons.play_circle_outline
                                : learningIcon(category),
                            color: i.isEven ? blue : orange),
                        title: Text('${i + 1}. ${sections[i].$1}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: navy)),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(20),
                              child: SelectableText(sections[i].$2,
                                  style: const TextStyle(
                                      fontSize: 17, height: 1.6, color: navy)))
                        ],
                      )),
                if (sections.isEmpty)
                  const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Lesson content has not been added yet.')),
                if (questions.isNotEmpty)
                  Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Color(0xFFE5EEF8))),
                      child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: const LearningIcon(
                        icon: Icons.emoji_events_rounded, color: green),
                    title: const Text('Practice and Application'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => QuizScreen(api: widget.api, test: {
                                  'title': 'Practice Time',
                                  'category': category,
                                  'questions': questions
                                }))),
                  )),
              ]))),
    );
  }
}

class EngagementScreen extends StatefulWidget {
  const EngagementScreen(
      {super.key, required this.api, required this.onJournal});
  final ApiService api;
  final VoidCallback onJournal;
  @override
  State<EngagementScreen> createState() => _EngagementScreenState();
}

class _EngagementScreenState extends State<EngagementScreen> {
  late Future<dynamic> future = widget.api.get('/progress');
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Learner Engagement')),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: OutlinedButton(
                        onPressed: () => setState(
                            () => future = widget.api.get('/progress')),
                        child: const Text('Try again')));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = Map<String, dynamic>.from(snapshot.data as Map);
              final count = (data['today_count'] as num? ?? 0).toInt();
              final achievements = data['achievements'] as List? ?? [];
              return ListView(padding: const EdgeInsets.all(20), children: [
                const ModuleOverview(category: 'engagement'),
                const SizedBox(height: 20),
                Card(
                    color: paleBlue,
                    child: ListTile(
                        contentPadding: const EdgeInsets.all(18),
                        leading: const Icon(Icons.track_changes,
                            color: blue, size: 42),
                        title: const Text("Today's Goal"),
                        subtitle: Text(
                            '$count activities completed today. Complete a lesson and reflect.'))),
                const SizedBox(height: 20),
                if (data['streak_days'] != null) ...[
                  Card(
                      color: orange.withValues(alpha: .08),
                      child: ListTile(
                          leading: const Icon(Icons.local_fire_department,
                              color: orange, size: 40),
                          title: Text(
                              '${data['streak_days']} day learning streak'),
                          subtitle: const Text(
                              'Practice each day to keep your streak going.'))),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                    onPressed: widget.onJournal,
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Reflection Journal')),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => LessonsScreen(
                                api: widget.api, category: 'vocabulary'))),
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Vocabulary Challenges')),
                const SizedBox(height: 24),
                const Text('Achievement Badges',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: navy)),
                if (achievements.isEmpty)
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                          'Complete learning activities to earn your first badge.')),
                ...achievements.map((entry) {
                  final badge = entry['achievement'] ?? entry;
                  return Card(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                          leading: const Icon(Icons.emoji_events,
                              color: orange, size: 36),
                          title: Text(badge['name'] ?? 'Achievement'),
                          subtitle: Text(badge['description'] ?? '')));
                }),
              ]);
            }),
      );
}

class ModuleOverview extends StatelessWidget {
  const ModuleOverview({super.key, required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    final (title, description, skills, color, icon) = switch (category) {
      'grammar' => (
          'Grammar',
          'Learn grammar through simple lessons and examples.',
          [
            'Parts of Speech',
            'Sentence Structure',
            'Verb Tenses',
            'Subject–Verb Agreement',
            'Punctuation',
            'Advanced Grammar'
          ],
          orange,
          Icons.article_rounded
        ),
      'vocabulary' => (
          'Vocabulary',
          'Build your word knowledge with context and practice.',
          [
            'Basic Vocabulary',
            'Word Meaning',
            'Word Formation',
            'Contextual Vocabulary',
            'Spelling and Pronunciation',
            'Advanced Vocabulary'
          ],
          pink,
          Icons.menu_book_rounded
        ),
      'reading' => (
          'Reading',
          'Develop comprehension skills with short passages.',
          [
            'Reading Strategies',
            'Main Idea',
            'Inference',
            'Context Clues',
            'Summary and Reflection'
          ],
          purple,
          Icons.auto_stories_rounded
        ),
      'engagement' => (
          'Learner Engagement',
          'Stay motivated with challenges and rewards.',
          [
            'Daily Goals',
            'Achievement Badges',
            'Reflections',
            'Vocabulary Challenges'
          ],
          green,
          Icons.groups_rounded
        ),
      _ => (
          'Diagnostic Tests',
          'Assess your current English proficiency.',
          ['Grammar', 'Vocabulary', 'Reading Comprehension'],
          blue,
          Icons.bar_chart_rounded
        ),
    };
    return Container(
        decoration: BoxDecoration(
            color: color.withValues(alpha: .06),
            borderRadius: BorderRadius.circular(22)),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 23)),
          const SizedBox(height: 16),
          Row(children: [
            LearningIcon(icon: icon, color: color),
            const SizedBox(width: 14),
            Expanded(
                child: Text(description,
                    style: const TextStyle(
                        color: navy, fontSize: 16, height: 1.4)))
          ]),
          const SizedBox(height: 14),
          ...skills.map((skill) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                const Icon(Icons.check, color: green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(skill, style: const TextStyle(color: navy)))
              ]))),
        ]));
  }
}

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key, required this.api});
  final ApiService api;
  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  late Future<dynamic> future = widget.api.get('/diagnostics');
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Diagnostic Tests')),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: OutlinedButton(
                        onPressed: () => setState(
                            () => future = widget.api.get('/diagnostics')),
                        child: const Text('Try again')));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tests = snapshot.data as List;
              return ListView(padding: const EdgeInsets.all(20), children: [
                const ModuleOverview(category: 'diagnostic'),
                const SizedBox(height: 24),
                if (tests.isEmpty)
                  const Text('No diagnostic test is published yet.'),
                ...tests.map((test) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(test['title'] ?? 'Diagnostic Test',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: navy)),
                              if (test['description'] != null) ...[
                                const SizedBox(height: 8),
                                Text(test['description'])
                              ],
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (_) => QuizScreen(
                                              api: widget.api,
                                              test: Map<String, dynamic>.from(
                                                  test)))),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Start Diagnostic Test')),
                            ])))),
              ]);
            }),
      );
}
