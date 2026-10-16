part of 'main.dart';

class _DashboardView extends StatelessWidget {
  const _DashboardView({
    required this.user,
    required this.progress,
    required this.error,
    required this.onRefresh,
    required this.onMenu,
    required this.onLessons,
    required this.onProgress,
    required this.onProfile,
    required this.onDiagnostic,
    required this.onCategory,
    required this.onEngagement,
    required this.onReflection,
    required this.lessons,
  });

  final Map<String, dynamic> user;
  final Map<String, dynamic>? progress;
  final String? error;
  final Future<void> Function() onRefresh;
  final VoidCallback? onMenu;
  final VoidCallback onLessons;
  final VoidCallback onProgress;
  final VoidCallback onProfile;
  final VoidCallback onDiagnostic;
  final ValueChanged<String> onCategory;
  final VoidCallback onEngagement;
  final VoidCallback onReflection;
  final Widget lessons;

  @override
  Widget build(BuildContext context) {
    final name = user['name']?.toString().trim().split(' ').first ?? 'Learner';
    final goal = progress?['daily_goal'] as Map? ?? {};
    final lessonDone = goal['lesson_completed'] == true;
    final reflectionDone = goal['reflection_saved'] == true;
    final steps = (lessonDone ? 1 : 0) + (reflectionDone ? 1 : 0);
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final modules = [
      (
        'Diagnostic Test',
        'Find your level',
        Icons.analytics_rounded,
        blue,
        onDiagnostic
      ),
      (
        'Grammar',
        'Build confidence',
        Icons.article_rounded,
        green,
        () => onCategory('grammar')
      ),
      (
        'Vocabulary',
        'Discover words',
        Icons.menu_book_rounded,
        pink,
        () => onCategory('vocabulary')
      ),
      (
        'Reading',
        'Explore stories',
        Icons.auto_stories_rounded,
        purple,
        () => onCategory('reading')
      ),
      (
        'Engagement',
        'Stay inspired',
        Icons.groups_rounded,
        green,
        onEngagement
      ),
      (
        'My Progress',
        'See your growth',
        Icons.emoji_events_rounded,
        orange,
        onProgress
      ),
    ];
    return ColoredBox(
      color: const Color(0xFFF6F8FC),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: LayoutBuilder(builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
          final columns = constraints.maxWidth < 360 || textScale > 1.15
              ? 2
              : constraints.maxWidth >= 1000
                  ? 6
                  : 3;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 28),
                children: [
                  Row(children: [
                    if (onMenu != null)
                      IconButton.filledTonal(
                        tooltip: 'Open navigation menu',
                        onPressed: onMenu,
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.white),
                        icon: const Icon(Icons.menu_rounded, color: navy),
                      ),
                    const SizedBox(width: 10),
                    const Expanded(
                        child: Text('SCAFFOLD ENG',
                            style: TextStyle(
                                color: muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8))),
                    IconButton(
                      tooltip: 'Your profile',
                      onPressed: onProfile,
                      icon: const CircleAvatar(
                          backgroundColor: paleBlue,
                          child: Icon(Icons.face_3_rounded, color: blue)),
                    ),
                  ]),
                  const SizedBox(height: 22),
                  _DashboardEntrance(
                    order: 0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, $name!',
                              style: const TextStyle(
                                  color: navy,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1)),
                          const SizedBox(height: 6),
                          const Text('A little learning. A brighter you.',
                              style: TextStyle(color: muted, fontSize: 15)),
                        ]),
                  ),
                  const SizedBox(height: 24),
                  _DashboardEntrance(
                    order: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                            colors: [Color(0xFF167FF2), Color(0xFF315BD5)]),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                              color: blue.withValues(alpha: .18),
                              blurRadius: 22,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: .16),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Icon(
                                      steps == 2
                                          ? Icons.task_alt_rounded
                                          : Icons.track_changes_rounded,
                                      color: Colors.white,
                                      size: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    const Text("Today's Goal",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    Text(
                                        steps == 2
                                            ? 'You did it. Keep growing!'
                                            : 'One lesson. One reflection.',
                                        style: const TextStyle(
                                            color: Color(0xFFE0EEFF),
                                            fontSize: 13)),
                                  ])),
                            ]),
                            const SizedBox(height: 20),
                            Row(children: [
                              Expanded(
                                  child: Text(
                                      progress == null
                                          ? 'Your daily learning journey'
                                          : '$steps of 2 steps complete',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600))),
                              if (progress != null)
                                Text('${steps * 50}%',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 9),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: steps / 2),
                              duration: Duration(
                                  milliseconds: reducedMotion ? 0 : 700),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) =>
                                  LinearProgressIndicator(
                                      value: value,
                                      minHeight: 7,
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor:
                                          Colors.white.withValues(alpha: .22),
                                      color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              _goalAction('Lesson', lessonDone,
                                  Icons.menu_book_rounded, onLessons),
                              _goalAction('Reflect', reflectionDone,
                                  Icons.edit_note_rounded, onReflection),
                            ]),
                          ]),
                    ),
                  ),
                  if (progress == null && error == null)
                    const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: LinearProgressIndicator(
                            semanticsLabel: 'Loading your progress')),
                  if (error != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(children: [
                          const Icon(Icons.cloud_off_rounded,
                              color: muted, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                              child: Text('Progress is unavailable. Try again.',
                                  style: TextStyle(color: muted))),
                          TextButton(
                              onPressed: onRefresh, child: const Text('Retry')),
                        ])),
                  const SizedBox(height: 24),
                  _sectionHeading('Explore & learn', 'All lessons', onLessons),
                  const SizedBox(height: 12),
                  for (var row = 0; row < modules.length; row += columns)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var index = row;
                                index < row + columns;
                                index++) ...[
                              if (index > row) const SizedBox(width: 10),
                              Expanded(
                                child: _DashboardEntrance(
                                  order: index + 2,
                                  child: _DashboardShortcut(
                                    title: modules[index].$1,
                                    subtitle: modules[index].$2,
                                    icon: modules[index].$3,
                                    accent: modules[index].$4,
                                    onTap: modules[index].$5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _sectionHeading('Continue learning', 'See all', onLessons),
                  const SizedBox(height: 12),
                  lessons,
                  const SizedBox(height: 16),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: blue, size: 16),
                        SizedBox(width: 7),
                        Flexible(
                            child: Text('Small steps make great progress.',
                                style: TextStyle(color: muted, fontSize: 12))),
                      ]),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeading(String title, String action, VoidCallback onTap) =>
      Builder(builder: (context) {
        if (MediaQuery.textScalerOf(context).scale(14) > 20) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800)),
                TextButton(onPressed: onTap, child: Text(action)),
              ]);
        }
        return Row(children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4))),
          TextButton(
              onPressed: onTap,
              child: Text(action, style: const TextStyle(fontSize: 12))),
        ]);
      });

  Widget _goalAction(
          String label, bool complete, IconData icon, VoidCallback onTap) =>
      TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: .14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
        icon: Icon(complete ? Icons.check_circle_rounded : icon, size: 18),
        label: Text(label),
      );
}

class _DashboardEntrance extends StatelessWidget {
  const _DashboardEntrance({required this.order, required this.child});
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + order * 65),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
              offset: Offset(0, 18 * (1 - value)), child: child)),
    );
  }
}

class _DashboardShortcut extends StatefulWidget {
  const _DashboardShortcut(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.accent,
      required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_DashboardShortcut> createState() => _DashboardShortcutState();
}

class _DashboardShortcutState extends State<_DashboardShortcut> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) => AnimatedScale(
        scale: pressed ? .96 : 1,
        duration: Duration(
            milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 140),
        child: Material(
          color: Color.alphaBlend(
              widget.accent.withValues(alpha: .065), Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: widget.accent.withValues(alpha: .1))),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) => setState(() => pressed = value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          color: widget.accent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: widget.accent.withValues(alpha: .2),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      child: Icon(widget.icon, color: Colors.white, size: 27),
                    ),
                    const SizedBox(height: 12),
                    Text(widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1.25)),
                    const SizedBox(height: 5),
                    Text(widget.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: muted, fontSize: 10, height: 1.3)),
                  ]),
            ),
          ),
        ),
      );
}
