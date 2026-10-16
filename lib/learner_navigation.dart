part of 'main.dart';

class _LearnerNavigation extends StatelessWidget {
  const _LearnerNavigation(
      {required this.selectedIndex,
      required this.onDestinationSelected,
      required this.onDiagnostic});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onDiagnostic;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final page = dark ? const Color(0xFF1C1919) : const Color(0xFFF6F7F9);
    final extraHeight = (MediaQuery.textScalerOf(context).scale(10) - 10)
        .clamp(0.0, double.infinity);
    return ColoredBox(
      color: page,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 26),
          child: SizedBox(
            height: 98 + extraHeight,
            child: Stack(alignment: Alignment.topCenter, children: [
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                child: Container(
                  height: 66 + extraHeight,
                  decoration: BoxDecoration(
                    color: dark ? const Color(0xFF211F24) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: dark
                            ? const Color(0xFF2C3141)
                            : const Color(0xFFDCDEE4)),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0D804EEC),
                          blurRadius: 4,
                          offset: Offset(0, -1)),
                      BoxShadow(
                          color: Color(0x47091948),
                          blurRadius: 34,
                          spreadRadius: -14,
                          offset: Offset(0, 18)),
                    ],
                  ),
                  child: Row(children: [
                    _tab(context, 0, 'Home', Icons.home_outlined,
                        Icons.home_rounded),
                    _tab(context, 1, 'Lessons', Icons.assignment_outlined,
                        Icons.assignment_rounded),
                    const Expanded(child: SizedBox()),
                    _tab(context, 2, 'Progress', Icons.bar_chart_outlined,
                        Icons.bar_chart_rounded),
                    _tab(context, 3, 'Profile', Icons.person_outline_rounded,
                        Icons.person_rounded),
                  ]),
                ),
              ),
              IgnorePointer(
                  child: Container(
                      width: 78,
                      height: 78,
                      decoration:
                          BoxDecoration(color: page, shape: BoxShape.circle))),
              Positioned(
                top: 9,
                child: Tooltip(
                  message: 'Start diagnostic test',
                  child: Semantics(
                    button: true,
                    label: 'Start diagnostic test',
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF976FEE), Color(0xFF804EEC)],
                            stops: [.0265, .7954]),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xBF804EEC),
                              blurRadius: 24,
                              spreadRadius: -8,
                              offset: Offset(0, 12))
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: onDiagnostic,
                          customBorder: const CircleBorder(),
                          child: const Icon(Icons.quiz_outlined,
                              size: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int destination, String label,
      IconData icon, IconData selectedIcon) {
    final selected = selectedIndex == destination;
    final color = selected ? const Color(0xFF804EEC) : const Color(0xFFAFB2BB);
    final duration = Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 280);
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        excludeSemantics: true,
        child: Tooltip(
          message: label,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onDestinationSelected(destination),
              child: SizedBox.expand(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<Color?>(
                        tween: ColorTween(end: color),
                        duration: duration,
                        builder: (context, value, child) => Icon(
                            selected ? selectedIcon : icon,
                            size: 21,
                            color: value),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: duration,
                        style: TextStyle(
                            fontSize: 10,
                            height: 1,
                            letterSpacing: -.05,
                            color: color,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500),
                        child: Text(label,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
