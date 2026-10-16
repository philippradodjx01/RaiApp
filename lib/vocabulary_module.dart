part of 'main.dart';

class VocabularyDashboard extends StatefulWidget {
  const VocabularyDashboard({super.key, required this.api, this.onMenu});
  final ApiService api;
  final VoidCallback? onMenu;
  @override
  State<VocabularyDashboard> createState() => _VocabularyDashboardState();
}

class _VocabularyDashboardState extends State<VocabularyDashboard> {
  late Future<List<dynamic>> data = load();
  Future<List<dynamic>> load() => Future.wait([
        widget.api.get('/vocabulary/categories'),
        widget.api.get('/vocabulary/progress'),
      ]);
  Future<void> open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() => data = load());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Vocabulary'),
            leading: widget.onMenu == null
                ? null
                : IconButton(
                    onPressed: widget.onMenu,
                    icon: const Icon(Icons.menu),
                    tooltip: 'Open navigation menu')),
        body: FutureBuilder<List<dynamic>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return VocabularyError(
                    error: snapshot.error,
                    retry: () => setState(() => data = load()));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data![0] as List;
              final p = snapshot.data![1] as Map;
              final daily = p['word_of_day'];
              final total = p['total_lessons'] as num;
              final completed = p['completed_lessons'] as num;
              return RefreshIndicator(
                  onRefresh: () async {
                    setState(() => data = load());
                    await data;
                  },
                  child: ListView(padding: const EdgeInsets.all(20), children: [
                    const Text('Build your word power',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        'Explore meanings, make connections, and use new words with confidence.',
                        style: TextStyle(color: muted)),
                    const SizedBox(height: 20),
                    VocabularyPanel(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('Your learning progress',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                              value: total == 0
                                  ? 0
                                  : (completed / total).clamp(0, 1)),
                          const SizedBox(height: 12),
                          Text('$completed / $total lessons completed'),
                          Text(
                              '${p['quizzes_completed']} quizzes · ${p['average_score']}% average · ${p['highest_score']}% best'),
                          Text(
                              '${(p['learned_words'] as List).length} words learned'),
                          if (p['last_lesson'] != null)
                            FilledButton(
                                onPressed: () => open(VocabularyLessonScreen(
                                    api: widget.api,
                                    id: p['last_lesson']['id'])),
                                child: const Text('Continue Learning')),
                        ])),
                    if (daily != null)
                      VocabularyPanel(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const Text('WORD OF THE DAY',
                                style: TextStyle(
                                    color: blue, fontWeight: FontWeight.bold)),
                            Text(daily['word'],
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            Text(
                                '${daily['pronunciation'] ?? ''} · ${daily['part_of_speech']}'),
                            Text(daily['meaning']),
                            Text(daily['example'] ?? ''),
                            if (pronunciationAvailable)
                              TextButton.icon(
                                  onPressed: () => pronounce(daily['word']),
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text('Listen')),
                          ])),
                    const Text('Choose a category',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    ...categories.map((c) => VocabularyPanel(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(c['name'],
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                              Text(c['description']),
                              const SizedBox(height: 8),
                              const Text('Beginner · Intermediate · Advanced',
                                  style: TextStyle(color: muted)),
                              FilledButton.tonal(
                                  onPressed: () => open(
                                      VocabularyCategoryScreen(
                                          api: widget.api,
                                          category:
                                              Map<String, dynamic>.from(c))),
                                  child: const Text('Start Learning')),
                            ]))),
                    if ((p['mastery'] as Map).isNotEmpty)
                      VocabularyPanel(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const Text('Category mastery',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            ...(p['mastery'] as Map).entries.map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${e.key} · ${e.value}%'),
                                      LinearProgressIndicator(
                                          value:
                                              (e.value as num).toDouble() / 100)
                                    ]))),
                            Text(
                                'Suggested review: ${(p['suggestions'] as List).join(', ')}'),
                          ])),
                    if ((p['incorrect_words'] as List).isNotEmpty)
                      VocabularyPanel(
                          child: Text(
                              'Words to revisit: ${(p['incorrect_words'] as List).map((w) => w['word']).join(', ')}')),
                    const Text('Test Results',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    if ((p['attempts'] as List).isEmpty)
                      const Text('Your completed quizzes will appear here.'),
                    ...(p['attempts'] as List).map((a) => ListTile(
                        title: Text(
                            '${a['quiz']?['category']?['name'] ?? 'Vocabulary'} · ${a['percentage']}%'),
                        subtitle: Text(
                            '${a['difficulty']} · ${a['score']}/${a['total']}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => open(VocabularyResultsScreen(
                            api: widget.api, id: a['id'])))),
                  ]));
            }),
      );
}

class VocabularyPanel extends StatelessWidget {
  const VocabularyPanel({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
          child: Padding(padding: const EdgeInsets.all(20), child: child)));
}

class VocabularyError extends StatelessWidget {
  const VocabularyError({super.key, required this.error, required this.retry});
  final Object? error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$error'),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: retry, child: const Text('Try again'))
          ])));
}

class VocabularyCategoryScreen extends StatefulWidget {
  const VocabularyCategoryScreen(
      {super.key, required this.api, required this.category});
  final ApiService api;
  final Map<String, dynamic> category;
  @override
  State<VocabularyCategoryScreen> createState() =>
      _VocabularyCategoryScreenState();
}

class _VocabularyCategoryScreenState extends State<VocabularyCategoryScreen> {
  late Future<dynamic> lessons =
      widget.api.get('/vocabulary/categories/${widget.category['id']}/lessons');
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.category['name'])),
      body: FutureBuilder(
          future: lessons,
          builder: (context, s) {
            if (s.hasError) {
              return VocabularyError(
                  error: s.error,
                  retry: () => setState(() => lessons = widget.api.get(
                      '/vocabulary/categories/${widget.category['id']}/lessons')));
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(padding: const EdgeInsets.all(20), children: [
              Text(widget.category['description']),
              const SizedBox(height: 16),
              for (final level in ['beginner', 'intermediate', 'advanced']) ...[
                Text(level.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: blue)),
                ...(s.data as List).where((l) => l['difficulty'] == level).map(
                    (l) => ListTile(
                        title: Text(l['title']),
                        subtitle: Text(l['objectives']),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VocabularyLessonScreen(
                                    api: widget.api, id: l['id']))))),
                const SizedBox(height: 16),
              ],
              FilledButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VocabularyQuizSetup(
                              api: widget.api,
                              categoryId: widget.category['id']))),
                  child: const Text('Take Quiz')),
            ]);
          }));
}

class VocabularyLessonScreen extends StatefulWidget {
  const VocabularyLessonScreen(
      {super.key, required this.api, required this.id});
  final ApiService api;
  final int id;
  @override
  State<VocabularyLessonScreen> createState() => _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState extends State<VocabularyLessonScreen> {
  late Future<dynamic> lesson = load();
  bool busy = false;
  Future<dynamic> load() => widget.api.get('/vocabulary/lessons/${widget.id}');
  Future<void> complete() async {
    setState(() => busy = true);
    try {
      await widget.api.post('/vocabulary/lessons/${widget.id}/complete');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Lesson completed. Your progress is saved.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    stopPronunciation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Lesson')),
      body: FutureBuilder(
          future: lesson,
          builder: (context, s) {
            if (s.hasError) {
              return VocabularyError(
                  error: s.error, retry: () => setState(() => lesson = load()));
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final l = s.data['lesson'];
            final next = s.data['next_lesson_id'];
            return ListView(padding: const EdgeInsets.all(20), children: [
              Text(l['title'],
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              VocabularyPanel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Learning objectives',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(l['objectives'])
                  ])),
              Text(l['content']),
              const SizedBox(height: 20),
              ...(l['words'] as List).map((w) => VocabularyPanel(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(w['word'],
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        Text(
                            '${w['pronunciation'] ?? ''} · ${w['part_of_speech']}'),
                        if (pronunciationAvailable)
                          TextButton.icon(
                              onPressed: () => pronounce(w['word']),
                              icon: const Icon(Icons.volume_up),
                              label: const Text('Listen')),
                        Text(w['meaning'],
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(
                            'Synonyms: ${(w['synonyms'] as List? ?? []).join(', ')}'),
                        Text(
                            'Antonyms: ${(w['antonyms'] as List? ?? []).join(', ')}'),
                        Text(w['usage'] ?? ''),
                        ...(w['examples'] as List).map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text('“${e['sentence']}”'))),
                      ]))),
              FilledButton(
                  onPressed: busy ? null : complete,
                  child: Text(busy ? 'Saving…' : 'Mark lesson complete')),
              OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VocabularyActivityScreen(
                              api: widget.api, lessonId: widget.id))),
                  child: const Text('Practice Now')),
              OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VocabularyQuizSetup(
                              api: widget.api,
                              categoryId: l['category_id'],
                              initialDifficulty: l['difficulty']))),
                  child: const Text('Take Quiz')),
              if (next != null)
                TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VocabularyLessonScreen(
                                api: widget.api, id: next))),
                    child: const Text('Next Lesson')),
            ]);
          }));
}

class VocabularyQuizSetup extends StatefulWidget {
  const VocabularyQuizSetup(
      {super.key,
      required this.api,
      required this.categoryId,
      this.initialDifficulty = 'beginner'});
  final ApiService api;
  final int categoryId;
  final String initialDifficulty;
  @override
  State<VocabularyQuizSetup> createState() => _VocabularyQuizSetupState();
}

class _VocabularyQuizSetupState extends State<VocabularyQuizSetup> {
  late String difficulty = widget.initialDifficulty;
  int count = 10;
  int timer = 0;
  bool busy = false;
  String? error;
  Future<void> start() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final data = await widget.api.post('/vocabulary/attempts', {
        'category_id': widget.categoryId,
        'difficulty': difficulty,
        'count': count,
        'timer_minutes': timer == 0 ? null : timer
      });
      if (mounted) {
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => VocabularyActivityScreen(
                    api: widget.api,
                    attemptData: Map<String, dynamic>.from(data))));
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Quiz')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('Check your understanding',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const Text(
            'Answers and explanations appear after submission. Unanswered questions count as incorrect.'),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
            initialValue: difficulty,
            decoration: const InputDecoration(labelText: 'Difficulty'),
            items: ['beginner', 'intermediate', 'advanced']
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: busy ? null : (v) => setState(() => difficulty = v!)),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
            initialValue: count,
            decoration: const InputDecoration(labelText: 'Questions'),
            items: [10, 20, 30]
                .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                .toList(),
            onChanged: busy ? null : (v) => setState(() => count = v!)),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
            initialValue: timer,
            decoration: const InputDecoration(labelText: 'Optional timer'),
            items: [0, 10, 20, 30]
                .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v == 0 ? 'No time limit' : '$v minutes')))
                .toList(),
            onChanged: busy ? null : (v) => setState(() => timer = v!)),
        const SizedBox(height: 20),
        if (error != null) Text(error!, style: const TextStyle(color: pink)),
        FilledButton(
            onPressed: busy ? null : start,
            child: Text(busy ? 'Preparing…' : 'Start Quiz')),
      ]));
}

class VocabularyActivityScreen extends StatefulWidget {
  const VocabularyActivityScreen(
      {super.key, required this.api, this.lessonId, this.attemptData});
  final ApiService api;
  final int? lessonId;
  final Map<String, dynamic>? attemptData;
  @override
  State<VocabularyActivityScreen> createState() =>
      _VocabularyActivityScreenState();
}

class _VocabularyActivityScreenState extends State<VocabularyActivityScreen> {
  bool get graded => widget.attemptData != null;
  late Future<dynamic> data = graded
      ? Future.value(widget.attemptData!['questions'])
      : widget.api.get('/vocabulary/lessons/${widget.lessonId}/practice');
  final Map<int, String> answers = {};
  final Map<int, Map<String, dynamic>> feedback = {};
  int index = 0;
  bool busy = false;
  String? error;
  Timer? ticker;
  int? remaining;
  Future<void> pendingSave = Future.value();
  @override
  void initState() {
    super.initState();
    final expires = widget.attemptData?['attempt']['expires_at'];
    if (expires != null) {
      final end = DateTime.parse(expires);
      remaining = end.difference(DateTime.now()).inSeconds;
      ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => remaining =
            end.difference(DateTime.now()).inSeconds.clamp(0, 7200));
        if (remaining == 0) {
          ticker?.cancel();
          submit();
        }
      });
    }
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  void answer(int id, String value) {
    setState(() {
      answers[id] = value;
      feedback.remove(id);
    });
    if (graded) {
      pendingSave = pendingSave.then((_) async {
        try {
          await widget.api.put(
              '/vocabulary/attempts/${widget.attemptData!['attempt']['id']}/answers',
              {
                'answers': [
                  {'id': id, 'answer': value}
                ]
              });
        } catch (e) {
          if (mounted) setState(() => error = 'Answer could not be saved: $e');
        }
      });
    }
  }

  Future<void> check(Map q) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await widget.api.post(
          '/vocabulary/practice/${q['id']}/check',
          {'answer': answers[q['id']] ?? ''});
      if (mounted) {
        setState(() => feedback[q['id']] = Map<String, dynamic>.from(result));
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> submit() async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await pendingSave;
      final id = widget.attemptData!['attempt']['id'];
      await widget.api.post('/vocabulary/attempts/$id/submit', {
        'answers': answers.entries
            .map((e) => {'id': e.key, 'answer': e.value})
            .toList()
      });
      if (mounted) {
        ticker?.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    VocabularyResultsScreen(api: widget.api, id: id)));
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: Text(graded ? 'Vocabulary Test' : 'Practice Exercises')),
      body: FutureBuilder(
          future: data,
          builder: (context, s) {
            if (s.hasError) {
              return VocabularyError(
                  error: s.error,
                  retry: () => setState(() => data = widget.api
                      .get('/vocabulary/lessons/${widget.lessonId}/practice')));
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final questions = s.data as List;
            if (questions.isEmpty) {
              return const Center(
                  child: Text('No practice activities are published yet.'));
            }
            final q = questions[index] as Map;
            final id = q['id'] as int;
            final choices = (q['options'] as List)
                .map((o) => o is Map ? o['body'] as String : o as String)
                .toList();
            final result = feedback[id];
            return ListView(padding: const EdgeInsets.all(24), children: [
              Text(
                  'Question ${index + 1} of ${questions.length} · ${answers.length} answered'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (index + 1) / questions.length),
              if (remaining != null)
                Text(
                    'Time remaining: ${remaining! ~/ 60}:${(remaining! % 60).toString().padLeft(2, '0')}'),
              const SizedBox(height: 24),
              Text((q['type'] as String).replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                      color: blue, fontWeight: FontWeight.bold)),
              Text(q['prompt'],
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (choices.isEmpty)
                TextFormField(
                    key: ValueKey(id),
                    initialValue: answers[id] ?? '',
                    enabled: !busy && remaining != 0,
                    decoration: const InputDecoration(labelText: 'Your answer'),
                    onChanged: (v) => answer(id, v))
              else
                ...choices.map((choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                        onPressed: busy || remaining == 0
                            ? null
                            : () => answer(id, choice),
                        style: OutlinedButton.styleFrom(
                            backgroundColor:
                                answers[id] == choice ? paleBlue : null,
                            padding: const EdgeInsets.all(18)),
                        child: Row(children: [
                          Icon(answers[id] == choice
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off),
                          const SizedBox(width: 12),
                          Expanded(child: Text(choice))
                        ])))),
              if (!graded)
                FilledButton(
                    onPressed: busy || (answers[id] ?? '').trim().isEmpty
                        ? null
                        : () => check(q),
                    child: const Text('Check Answer')),
              if (result != null)
                VocabularyPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(result['correct'] ? 'Correct!' : 'Keep practicing',
                          style: TextStyle(
                              color: result['correct'] ? green : pink,
                              fontWeight: FontWeight.bold)),
                      Text('Correct answer: ${result['answer']}'),
                      Text(result['explanation'])
                    ])),
              if (error != null)
                Text(error!, style: const TextStyle(color: pink)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                    onPressed: index == 0 || busy
                        ? null
                        : () => setState(() => index--),
                    child: const Text('Previous')),
                TextButton(
                    onPressed: index == questions.length - 1 || busy
                        ? null
                        : () => setState(() => index++),
                    child: const Text('Next'))
              ]),
              if (graded)
                FilledButton(
                    onPressed: busy
                        ? null
                        : () async {
                            final confirm = await showDialog<bool>(
                                context: context,
                                builder: (c) => AlertDialog(
                                        title: const Text('Submit Test?'),
                                        content: Text(
                                            '${questions.length - answers.length} unanswered questions. Your answers will be final.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(c, false),
                                              child:
                                                  const Text('Continue test')),
                                          FilledButton(
                                              onPressed: () =>
                                                  Navigator.pop(c, true),
                                              child: const Text('Submit Test'))
                                        ]));
                            if (confirm == true) submit();
                          },
                    child: Text(busy ? 'Submitting…' : 'Submit Test')),
              if (!graded && index == questions.length - 1)
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Learning')),
            ]);
          }));
}

class VocabularyResultsScreen extends StatefulWidget {
  const VocabularyResultsScreen(
      {super.key, required this.api, required this.id});
  final ApiService api;
  final int id;
  @override
  State<VocabularyResultsScreen> createState() =>
      _VocabularyResultsScreenState();
}

class _VocabularyResultsScreenState extends State<VocabularyResultsScreen> {
  late Future<dynamic> result = load();
  bool review = false;
  Future<dynamic> load() =>
      widget.api.get('/vocabulary/attempts/${widget.id}/results');
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: FutureBuilder(
          future: result,
          builder: (context, s) {
            if (s.hasError) {
              return VocabularyError(
                  error: s.error, retry: () => setState(() => result = load()));
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final r = s.data;
            final a = r['attempt'];
            return ListView(padding: const EdgeInsets.all(24), children: [
              Icon(r['passed'] ? Icons.emoji_events : Icons.auto_stories,
                  size: 64, color: r['passed'] ? gold : blue),
              Text('${a['percentage']}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold)),
              Text(r['passed'] ? 'Pass' : 'Keep learning · Fail',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22)),
              VocabularyPanel(
                  child: Column(children: [
                Text(
                    '${a['score']} correct · ${r['incorrect']} incorrect · ${a['total']} questions'),
                Text('Passing score: ${a['passing_score']}%'),
                Text('Time spent: ${a['time_spent']} seconds')
              ])),
              FilledButton(
                  onPressed: () => setState(() => review = !review),
                  child: const Text('Review Answers')),
              if (review)
                ...(r['review'] as List).map((q) => VocabularyPanel(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(q['correct'] ? '✓ Correct' : '✗ Incorrect',
                              style: TextStyle(
                                  color: q['correct'] ? green : pink)),
                          Text(q['prompt'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              'Your answer: ${q['selected_answer'] ?? 'Unanswered'}'),
                          Text('Correct answer: ${q['answer']}'),
                          Text(q['explanation'])
                        ]))),
              if (a['quiz_id'] != null)
                OutlinedButton(
                    onPressed: () async {
                      try {
                        final categories = await widget.api
                            .get('/vocabulary/categories') as List;
                        final match = categories
                            .where((c) => c['quiz']?['id'] == a['quiz_id']);
                        if (!context.mounted) return;
                        if (match.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'This quiz is no longer published.')));
                          return;
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VocabularyQuizSetup(
                                    api: widget.api,
                                    categoryId: match.first['id'],
                                    initialDifficulty: a['difficulty'])));
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    },
                    child: const Text('Retry Quiz')),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continue Learning')),
              TextButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Back to Dashboard')),
            ]);
          }));
}
