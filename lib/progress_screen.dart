part of 'main.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.api, this.onMenu});
  final ApiService api;
  final VoidCallback? onMenu;
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Future<dynamic> future = widget.api.get('/progress');
  String selected = 'overall';
  void reload() => setState(() => future = widget.api.get('/progress'));

  Widget areaRow(String category, num score, {required bool strength}) =>
      ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 3),
        leading: Icon(strength ? Icons.check_circle : Icons.warning_rounded,
            color: strength ? green : orange, size: 30),
        title: Text('${areaTitle(category)} (${score.round()}%)',
            style: const TextStyle(color: navy, fontSize: 17)),
        trailing: const Icon(Icons.chevron_right, color: muted),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) =>
                    LessonsScreen(api: widget.api, category: category))),
      );

  Widget heading(String title) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              color: navy, fontSize: 21, fontWeight: FontWeight.w800)));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: AppBar(
          leading: widget.onMenu == null
              ? null
              : IconButton(
                  tooltip: 'Open navigation menu',
                  onPressed: () => widget.onMenu?.call(),
                  icon: const Icon(Icons.menu_rounded)),
          backgroundColor: const Color(0xFFF6F8FC),
          title: const Text('My Progress'),
        ),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('We couldn’t load your progress.'),
                  OutlinedButton(
                      onPressed: reload, child: const Text('Try again'))
                ]));
              }
              final data = Map<String, dynamic>.from(snapshot.data as Map);
              final categories =
                  Map<String, dynamic>.from(data['by_category'] ?? {});
              final score = (selected == 'overall'
                  ? data['mastery']
                  : categories[selected]) as num?;
              final value = ((score ?? 0) / 100).clamp(0.0, 1.0);
              final measured = categories.entries
                  .where((e) =>
                      ['grammar', 'vocabulary', 'reading'].contains(e.key) &&
                      e.value is num &&
                      (selected == 'overall' || selected == e.key))
                  .toList();
              final strengths =
                  measured.where((e) => (e.value as num) >= 70).toList();
              final improvements =
                  measured.where((e) => (e.value as num) < 70).toList();
              final activities = (data['activities'] as List? ?? [])
                  .where(
                      (e) => selected == 'overall' || e['category'] == selected)
                  .toList();
              final recommendations = (data['recommendations'] as List? ?? [])
                  .where(
                      (e) => selected == 'overall' || e['category'] == selected)
                  .toList();
              return RefreshIndicator(
                  onRefresh: () async {
                    reload();
                    await future;
                  },
                  child: Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(22, 12, 22, 28),
                              children: [
                                LayoutBuilder(
                                    builder: (context, constraints) => Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          'overall',
                                          'grammar',
                                          'vocabulary',
                                          'reading'
                                        ]
                                            .map((category) => ChoiceChip(
                                                  padding: EdgeInsets.zero,
                                                  labelPadding: const EdgeInsets
                                                      .symmetric(horizontal: 7),
                                                  label:
                                                      Text(areaTitle(category)),
                                                  selected:
                                                      selected == category,
                                                  showCheckmark: false,
                                                  selectedColor: blue,
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                      color:
                                                          selected == category
                                                              ? Colors.white
                                                              : navy,
                                                      fontSize: 13),
                                                  side: const BorderSide(
                                                      color: line),
                                                  onSelected: (_) => setState(
                                                      () =>
                                                          selected = category),
                                                ))
                                            .toList())),
                                const SizedBox(height: 20),
                                Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        side: const BorderSide(color: line)),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 24),
                                        child: Column(children: [
                                          SizedBox(
                                              width: 164,
                                              height: 164,
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: 148,
                                                        height: 148,
                                                        child:
                                                            CircularProgressIndicator(
                                                                value: value,
                                                                strokeWidth: 18,
                                                                backgroundColor:
                                                                    line,
                                                                color: blue)),
                                                    SizedBox(
                                                        width: 148,
                                                        height: 148,
                                                        child: Transform.rotate(
                                                            angle: 1.5707963268,
                                                            child: CircularProgressIndicator(
                                                                value: (value -
                                                                        .25)
                                                                    .clamp(
                                                                        0.0,
                                                                        .75),
                                                                strokeWidth: 18,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                color: green))),
                                                    Text(
                                                        score == null
                                                            ? '—'
                                                            : '${score.round()}%',
                                                        style: const TextStyle(
                                                            fontSize: 36,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: navy)),
                                                  ])),
                                          const SizedBox(height: 14),
                                          Text('${areaTitle(selected)} Mastery',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: navy)),
                                          const SizedBox(height: 6),
                                          Text(
                                              score == null ||
                                                      (data['results'] as List? ?? [])
                                                              .isEmpty &&
                                                          categories.isEmpty
                                                  ? 'Complete an assessment to see your mastery.'
                                                  : score >= 70
                                                      ? 'Good Progress! Keep your learning streak going.'
                                                      : 'Keep practicing, one step at a time.',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 15, color: muted)),
                                        ]))),
                                heading('Strengths'),
                                if (strengths.isEmpty)
                                  const Text(
                                      'Skills at 70% or above will appear here.',
                                      style: TextStyle(color: muted)),
                                ...strengths.map((e) => areaRow(
                                    e.key, e.value as num,
                                    strength: true)),
                                heading('Areas for Improvement'),
                                if (improvements.isEmpty)
                                  Text(
                                      measured.isEmpty
                                          ? 'Complete an assessment to identify your next focus.'
                                          : 'All assessed areas are at 70% or above.',
                                      style: const TextStyle(color: muted)),
                                ...improvements.map((e) => areaRow(
                                    e.key, e.value as num,
                                    strength: false)),
                                heading('By learning area'),
                                ...['grammar', 'vocabulary', 'reading']
                                    .where((category) =>
                                        selected == 'overall' ||
                                        category == selected)
                                    .map((category) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(children: [
                                          Row(children: [
                                            Expanded(
                                                child: Text(areaTitle(category),
                                                    style: const TextStyle(
                                                        color: navy,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Text(
                                                categories[category] == null
                                                    ? 'Not assessed'
                                                    : '${categories[category]}%',
                                                style: const TextStyle(
                                                    color: blue))
                                          ]),
                                          const SizedBox(height: 10),
                                          LinearProgressIndicator(
                                              value: ((categories[category]
                                                              as num? ??
                                                          0) /
                                                      100)
                                                  .clamp(0.0, 1.0),
                                              backgroundColor: line,
                                              color: learningColor(category),
                                              minHeight: 7),
                                        ]))),
                                if (recommendations.isNotEmpty) ...[
                                  heading('Recommended Lessons'),
                                  ...recommendations.map((lesson) => Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      color: paleBlue,
                                      child: ListTile(
                                          title: Text(lesson['title']),
                                          subtitle: Text(
                                              areaTitle(lesson['category'])),
                                          trailing:
                                              const Icon(Icons.chevron_right),
                                          onTap: () => openLesson(
                                              context,
                                              widget.api,
                                              Map<String, dynamic>.from(
                                                  lesson))))),
                                ],
                                heading('Recent activities'),
                                if (activities.isEmpty)
                                  const Text(
                                      'Complete an activity to see it here.',
                                      style: TextStyle(color: muted)),
                                ...activities.take(10).map((activity) =>
                                    ListTile(
                                        leading: const Icon(Icons.check_circle,
                                            color: green),
                                        title: Text(
                                            (activity['activity_type'] ??
                                                    'Learning activity')
                                                .toString()
                                                .replaceAll('_', ' ')),
                                        subtitle: Text(
                                            areaTitle(activity['category'] ??
                                                'general')))),
                              ]))));
            }),
      );
}
