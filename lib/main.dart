import 'package:flutter/material.dart';
import 'dart:async';
import 'services/api_service.dart';
import 'services/pronunciation.dart';

part 'learning_screens.dart';
part 'progress_screen.dart';
part 'dashboard.dart';
part 'learner_navigation.dart';
part 'grammar_guide.dart';
part 'vocabulary_practice.dart';
part 'vocabulary_module.dart';

const navy = Color(0xFF14274E);
const gold = Color(0xFFF4B942);
const canvas = Color(0xFFFFFFFF);
const ink = Color(0xFF10244C);
const muted = Color(0xFF68758A);
const line = Color(0xFFE3EDF7);
const blue = Color(0xFF007CF0);
const paleBlue = Color(0xFFE9F5FF);
const green = Color(0xFF0CA678);
const orange = Color(0xFFFF9E0B);
const purple = Color(0xFF7650E8);
const pink = Color(0xFFF34260);

void main() => runApp(const ScaffoldEngApp());

class ScaffoldEngApp extends StatelessWidget {
  const ScaffoldEngApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SCAFFOLD-ENG',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(
            seedColor: blue,
            primary: blue,
            secondary: gold,
            surface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: canvas,
            foregroundColor: ink,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontFamily: 'Roboto',
              color: ink,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: line),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 22,
            ),
            labelStyle: const TextStyle(color: muted, fontSize: 17),
            hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFD92D20)),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 62),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: line),
              minimumSize: const Size(48, 58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            height: 74,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            indicatorColor: paleBlue,
            iconTheme: WidgetStateProperty.resolveWith((states) =>
                IconThemeData(
                    size: 29,
                    color:
                        states.contains(WidgetState.selected) ? blue : muted)),
            labelTextStyle:
                WidgetStateProperty.resolveWith((states) => TextStyle(
                      fontSize: 12,
                      fontWeight: states.contains(WidgetState.selected)
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color:
                          states.contains(WidgetState.selected) ? blue : muted,
                    )),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        home: const SplashScreen(),
      );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool ready = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => ready = true);
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: ready
            ? const AuthGate(key: ValueKey('auth'))
            : Scaffold(
                key: const ValueKey('splash'),
                backgroundColor: const Color(0xFFF4F9FF),
                body: Stack(fit: StackFit.expand, children: [
                  Image.asset('assets/images/splash_background.png',
                      fit: BoxFit.fill, excludeFromSemantics: true),
                  SafeArea(
                      child: LayoutBuilder(
                          builder: (context, constraints) =>
                              SingleChildScrollView(
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          24,
                                          constraints.maxHeight * .14,
                                          24,
                                          constraints.maxHeight * .3),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                'assets/images/learning_logo.png',
                                                width: 180,
                                                height: 170,
                                                excludeFromSemantics: true),
                                            const SizedBox(height: 20),
                                            RichText(
                                                textAlign: TextAlign.center,
                                                text: const TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        letterSpacing: -.8),
                                                    children: [
                                                      TextSpan(
                                                          text: 'SCAFFOLD-',
                                                          style: TextStyle(
                                                              color: navy)),
                                                      TextSpan(
                                                          text: 'ENG',
                                                          style: TextStyle(
                                                              color: blue))
                                                    ])),
                                            const SizedBox(height: 10),
                                            const Text(
                                                'Mobile-Assisted\nEnglish Learning App',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: navy,
                                                    fontSize: 21,
                                                    height: 1.4)),
                                            const SizedBox(height: 24),
                                            const Text(
                                                'Small Steps.\nStronger English.\nBigger Possibilities.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF31547D),
                                                    fontSize: 22,
                                                    height: 1.4,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                          ]),
                                    )),
                              ))),
                ]),
              ),
      );
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final api = ApiService();
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      if (await api.token != null) user = await api.profile();
    } catch (_) {
      await api.clearToken();
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user == null) {
      return LoginScreen(
        api: api,
        onLogin: (value) => setState(() => user = value),
      );
    }
    return LearnerShell(
      api: api,
      user: user!,
      onLogout: () => setState(() => user = null),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.api, required this.onLogin});
  final ApiService api;
  final ValueChanged<Map<String, dynamic>> onLogin;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final login = TextEditingController();
  final studentId = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool busy = false;
  bool visible = false;
  bool registering = false;
  String? error;

  @override
  void dispose() {
    for (final controller in [name, login, studentId, password, confirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      final user = registering
          ? await widget.api.register(
              name.text.trim(),
              login.text.trim(),
              studentId.text,
              password.text,
              confirmation.text,
            )
          : await widget.api.login(login.text.trim(), password.text);
      if (mounted) widget.onLogin(user);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            registering ? 'Create your account' : 'Welcome Back!',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: ink,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            registering
                ? 'Start building your English, one small step at a time.'
                : "Let's continue your English learning journey.",
            style: const TextStyle(color: navy, fontSize: 18, height: 1.5),
          ),
          SizedBox(height: registering ? 30 : 64),
          if (registering) ...[
            TextFormField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your name'
                  : null,
            ),
            const SizedBox(height: 14),
          ],
          TextFormField(
            controller: login,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            decoration: InputDecoration(
              labelText: registering ? 'Email address' : 'Student ID / Email',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? (registering
                    ? 'Enter your email'
                    : 'Enter your email or student ID')
                : null,
          ),
          if (registering) ...[
            const SizedBox(height: 14),
            TextFormField(
              controller: studentId,
              decoration: const InputDecoration(
                labelText: 'Student ID (optional)',
                prefixIcon: Icon(Icons.credit_card_outlined),
              ),
            ),
          ],
          const SizedBox(height: 14),
          TextFormField(
            controller: password,
            obscureText: !visible,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: visible ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => visible = !visible),
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your password' : null,
          ),
          if (registering) ...[
            const SizedBox(height: 14),
            TextFormField(
              controller: confirmation,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                prefixIcon: Icon(Icons.verified_user_outlined),
              ),
              validator: (value) =>
                  value != password.text ? 'Passwords do not match' : null,
            ),
          ],
          if (!registering)
            const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Tooltip(
                message: 'Password recovery is currently unavailable.',
                child: TextButton(
                    onPressed: null, child: Text('Forgot Password?')),
              ),
            ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline,
                      size: 18, color: Color(0xFFB42318)),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      error!,
                      style: const TextStyle(color: Color(0xFFB42318)),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : submit,
            child: busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(registering ? 'Create account' : 'Login'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          if (!registering) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Row(children: [
                Expanded(child: Divider(color: line)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('or continue with',
                        style: TextStyle(color: muted))),
                Expanded(child: Divider(color: line))
              ]),
            ),
            const Tooltip(
              message: 'Google sign-in is currently unavailable.',
              child: OutlinedButton(
                  onPressed: null,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('G',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        SizedBox(width: 14),
                        Text('Continue with Google')
                      ])),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: busy
                ? null
                : () => setState(() {
                      registering = !registering;
                      error = null;
                    }),
            child: Text(registering
                ? 'Already registered? Sign in'
                : 'Create an Account'),
          ),
        ],
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          if (wide) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(34),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                            color: paleBlue,
                            borderRadius: BorderRadius.circular(32)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school_rounded, color: blue, size: 72),
                              SizedBox(height: 20),
                              Text('SCAFFOLD-ENG',
                                  style: TextStyle(
                                      color: navy,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1)),
                              SizedBox(height: 10),
                              Text('Mobile-Assisted English Learning App',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: muted, height: 1.5)),
                              SizedBox(height: 24),
                              Text(
                                  'Small Steps.\nStronger English.\nBigger Possibilities.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: navy,
                                      fontSize: 20,
                                      height: 1.45,
                                      fontStyle: FontStyle.italic)),
                            ]),
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(48),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: formContent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formContent,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LearningPill extends StatelessWidget {
  const _LearningPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: .16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: blue, size: 16),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(color: navy, fontSize: 12)),
          ],
        ),
      );
}

class LearnerShell extends StatefulWidget {
  const LearnerShell({
    super.key,
    required this.api,
    required this.user,
    required this.onLogout,
  });
  final ApiService api;
  final Map<String, dynamic> user;
  final VoidCallback onLogout;
  @override
  State<LearnerShell> createState() => _LearnerShellState();
}

class _LearnerShellState extends State<LearnerShell> {
  int index = 0;
  int homeRevision = 0;
  final shellKey = GlobalKey<ScaffoldState>();

  void openJournal() {
    shellKey.currentState?.closeDrawer();
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(
            api: widget.api,
            user: widget.user,
            onLogout: widget.onLogout,
            journalOnly: true)));
  }

  void openEngagement() {
    shellKey.currentState?.closeDrawer();
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => EngagementScreen(api: widget.api, onJournal: openJournal)));
  }

  void selectTab(int value) {
    shellKey.currentState?.closeDrawer();
    setState(() => index = value);
  }

  Future<void> openDiagnostic() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => DiagnosticScreen(api: widget.api)));
    if (mounted) setState(() => homeRevision++);
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1000 &&
        MediaQuery.sizeOf(context).height >= 600 &&
        MediaQuery.textScalerOf(context).scale(14) <= 21;
    final pages = [
      HomeScreen(
        key: ValueKey(homeRevision),
        api: widget.api,
        user: widget.user,
        onMenu: () => shellKey.currentState?.openDrawer(),
        onLessons: () => setState(() => index = 1),
        onProgress: () => setState(() => index = 2),
        onJournal: () => setState(() => index = 3),
      ),
      LessonsScreen(
          api: widget.api,
          onMenu: () => shellKey.currentState?.openDrawer()),
      ProgressScreen(
          api: widget.api,
          onMenu: () => shellKey.currentState?.openDrawer()),
      ProfileScreen(
        api: widget.api,
        user: widget.user,
        onLogout: widget.onLogout,
        onMenu: () => shellKey.currentState?.openDrawer(),
      ),
    ];
    return Scaffold(
      key: shellKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [navy, blue],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 18),
                    const Text('SCAFFOLD-ENG',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .6)),
                    const SizedBox(height: 5),
                    Text(widget.user['name']?.toString() ?? 'Learner',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                  children: [
                    _drawerItem(Icons.home_rounded, 'Home', 0, selectTab),
                    _drawerItem(
                        Icons.menu_book_rounded, 'Lessons', 1, selectTab),
                    _drawerItem(
                        Icons.insights_rounded, 'My Progress', 2, selectTab),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text('YOUR LEARNING',
                          style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.track_changes_rounded),
                      title: const Text('Engagement'),
                      onTap: openEngagement,
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit_note_rounded),
                      title: const Text('Reflection Journal'),
                      onTap: openJournal,
                    ),
                    _drawerItem(
                        Icons.person_outline_rounded, 'Profile', 3, selectTab),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Row(children: [
                  const Icon(Icons.verified_user_outlined,
                      color: green, size: 19),
                  const SizedBox(width: 9),
                  Expanded(
                      child: Text(
                    widget.user['email']?.toString() ?? 'Learner account',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, fontSize: 12),
                  )),
                ]),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Row(children: [
          if (desktop) ...[
            NavigationRail(
              extended: true,
              backgroundColor: Colors.white,
              indicatorColor: paleBlue,
              selectedIndex: index,
              onDestinationSelected: selectTab,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Text('SCAFFOLD ENG', style: TextStyle(color: navy, fontWeight: FontWeight.w800)),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), label: Text('Lessons')),
                NavigationRailDestination(icon: Icon(Icons.insights_rounded), label: Text('Progress')),
                NavigationRailDestination(icon: Icon(Icons.person_outline_rounded), label: Text('Profile')),
              ],
            ),
            const VerticalDivider(width: 1),
          ],
          Expanded(child: pages[index]),
        ]),
      ),
      bottomNavigationBar: desktop ? null : _LearnerNavigation(
        selectedIndex: index,
        onDestinationSelected: selectTab,
        onDiagnostic: openDiagnostic,
      ),
    );
  }

  Widget _drawerItem(
      IconData icon, String label, int destination, ValueChanged<int> onSelect) {
    final selected = index == destination;
    return ListTile(
      leading: Icon(icon, color: selected ? blue : muted),
      title: Text(label,
          style: TextStyle(
              color: selected ? blue : navy,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      selected: selected,
      selectedTileColor: paleBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: () => onSelect(destination),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.api,
      required this.user,
      this.onMenu,
      required this.onLessons,
      required this.onProgress,
      required this.onJournal});
  final ApiService api;
  final Map<String, dynamic> user;
  final VoidCallback? onMenu;
  final VoidCallback onLessons;
  final VoidCallback onProgress;
  final VoidCallback onJournal;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? progress;
  String? error;
  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final value = await widget.api.get('/progress');
      if (mounted) {
        setState(() {
          progress = Map<String, dynamic>.from(value);
          error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    }
  }

  Future<void> openCategory(String category) async {
    await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) =>
                LessonsScreen(api: widget.api, category: category)));
    if (mounted) _loadProgress();
  }

  Future<void> openJournal() async {
    await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => ProfileScreen(
                api: widget.api,
                user: widget.user,
                onLogout: () {},
                journalOnly: true)));
    if (mounted) _loadProgress();
  }

  Future<void> openEngagement() async {
    await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) =>
                EngagementScreen(api: widget.api, onJournal: openJournal)));
    if (mounted) _loadProgress();
  }

  Future<void> startQuiz() async {
    await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => DiagnosticScreen(api: widget.api)));
    if (mounted) _loadProgress();
  }

  @override
  Widget build(BuildContext context) => _DashboardView(
        user: widget.user,
        progress: progress,
        error: error,
        onRefresh: _loadProgress,
        onMenu: widget.onMenu,
        onLessons: widget.onLessons,
        onProgress: widget.onProgress,
        onProfile: widget.onJournal,
        onDiagnostic: startQuiz,
        onCategory: openCategory,
        onEngagement: openEngagement,
        onReflection: openJournal,
        lessons: LessonFeed(api: widget.api, onReturn: _loadProgress),
      );
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.features,
    required this.actionLabel,
    required this.onTap,
  });

  final int number;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final List<String> features;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2EDF8)),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: .09), blurRadius: 16, offset: const Offset(0, 5))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(width: 42, height: 42, alignment: Alignment.center, decoration: BoxDecoration(color: accent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
              Expanded(child: Container(height: 42, alignment: AlignmentDirectional.centerStart, padding: const EdgeInsetsDirectional.only(start: 12, end: 10), decoration: BoxDecoration(gradient: LinearGradient(colors: [accent, accent.withValues(alpha: .82)]), borderRadius: const BorderRadiusDirectional.horizontal(end: Radius.circular(14))), child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)))),
            ]),
            const SizedBox(height: 11),
            Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: accent.withValues(alpha: .1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: accent, size: 29)),
              const SizedBox(width: 11),
              Expanded(child: Text(description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: navy, fontSize: 13, height: 1.3))),
            ]),
            const SizedBox(height: 8),
            ...features.map((feature) => Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Row(children: [const Icon(Icons.check_rounded, color: green, size: 17), const SizedBox(width: 7), Expanded(child: Text(feature, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: navy, fontSize: 12, height: 1.25)))]))),
            const Spacer(),
            const SizedBox(height: 8),
            SizedBox(height: 44, child: FilledButton(onPressed: onTap, style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(actionLabel), const SizedBox(width: 8), const Icon(Icons.arrow_forward_rounded, size: 19)]))),
          ]),
        ),
      );
}
class LessonFeed extends StatelessWidget {
  const LessonFeed({super.key, required this.api, this.onReturn});
  final VoidCallback? onReturn;
  final ApiService api;
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: api.get('/lessons'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (!snapshot.hasData) {
            return const Text(
              'Recommended lessons appear here when the server is connected.',
            );
          }
          final lessons = snapshot.data as List;
          return Column(
            children: lessons
                .take(3)
                .map(
                  (lesson) => Card(
                    color: paleBlue,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () async {
                        await openLesson(
                            context, api, Map<String, dynamic>.from(lesson));
                        onReturn?.call();
                      },
                      leading: const LearningIcon(
                          icon: Icons.menu_book_rounded, color: blue),
                      title: Text(
                        lesson['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${lesson['category']} · ${lesson['duration_minutes']} min',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 15, color: muted),
                    ),
                  ),
                )
                .toList(),
          );
        },
      );
}

class LessonsScreen extends StatefulWidget {
  const LessonsScreen(
      {super.key, required this.api, this.category, this.onMenu});
  final String? category;
  final ApiService api;
  final VoidCallback? onMenu;
  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String? grammarCategory;
  late Future<dynamic> future = widget.api.get('/lessons');
  void reload() => setState(() => future = widget.api.get('/lessons'));
  @override
  Widget build(BuildContext context) => widget.category == 'vocabulary' ? VocabularyDashboard(api: widget.api, onMenu: widget.onMenu) : Scaffold(
        appBar: AppBar(
          leading: widget.onMenu == null
              ? null
              : IconButton(
                  tooltip: 'Open navigation menu',
                  onPressed: () => widget.onMenu?.call(),
                  icon: const Icon(Icons.menu_rounded)),
          title: Text(
              widget.category == null ? 'Lessons' : areaTitle(widget.category!),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 42, color: muted),
                        const SizedBox(height: 12),
                        const Text('We couldn’t load your lessons.'),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                            onPressed: reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try again'))
                      ])));
            }
            final lessons = (snapshot.data as List)
                .where((lesson) =>
                    widget.category == null ||
                    lesson['category'] == widget.category)
                .toList();
            final isVocabulary = widget.category == 'vocabulary';
            final categoryField = isVocabulary ? 'vocabulary_category' : 'grammar_category';
            final orderField = isVocabulary ? 'vocabulary_order' : 'grammar_order';
            if (lessons.isEmpty) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Text('New lessons are coming soon.',
                          style: TextStyle(color: muted))));
            }
            if (widget.category == 'grammar' || isVocabulary) {
              lessons.sort((a, b) => ((a[orderField] as num?) ?? 9999)
                  .compareTo((b[orderField] as num?) ?? 9999));
            }
            final grammarCategories = lessons
                .map((lesson) => lesson[categoryField] as String?)
                .whereType<String>()
                .toSet();
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (widget.category != null) ...[
                  ModuleOverview(category: widget.category!),
                  const SizedBox(height: 20)
                ],
                if (widget.category == 'grammar') ...[
                  const GrammarGuideCard(),
                  const SizedBox(height: 20),
                ],
                if (isVocabulary) ...[
                  VocabularyPracticeCard(words: [
                    for (final lesson in lessons)
                      ...List<Map<String, dynamic>>.from(lesson['vocabulary_words'] ?? []),
                  ]),
                  const SizedBox(height: 20),
                ],
                if ((widget.category == 'grammar' || isVocabulary) && grammarCategories.isNotEmpty) ...[
                  Text('${grammarCategories.length} categories · ${lessons.length} lessons',
                      style: const TextStyle(color: muted)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                        label: const Text('All lessons'),
                        selected: grammarCategory == null,
                        onSelected: (_) => setState(() => grammarCategory = null)),
                    for (final category in grammarCategories)
                      ChoiceChip(
                          label: Text(category),
                          selected: grammarCategory == category,
                          onSelected: (_) => setState(() => grammarCategory = category)),
                  ]),
                  const SizedBox(height: 20),
                ],
                ...lessons.where((lesson) => (widget.category != 'grammar' && !isVocabulary) ||
                    grammarCategory == null || lesson[categoryField] == grammarCategory).map(
                  (lesson) => Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      leading: LearningIcon(
                          icon: learningIcon(lesson['category']),
                          color: learningColor(lesson['category'])),
                      shape: const RoundedRectangleBorder(),
                      title: Text(
                        lesson['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${lesson[categoryField] ?? lesson['category']} · ${lesson['duration_minutes']} min',
                      ),
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                    onPressed: () => openLesson(
                                        context,
                                        widget.api,
                                        Map<String, dynamic>.from(lesson)),
                                    icon: const Icon(Icons.play_circle_outline),
                                    label: const Text('Start Lesson')))),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              color: learningColor(lesson['category'])
                                  .withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(children: [
                            Icon(learningIcon(lesson['category']),
                                color: learningColor(lesson['category']),
                                size: 76),
                            const SizedBox(height: 16),
                            Text(lesson['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 23,
                                    color: navy)),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Text(
                            lesson['content'] ??
                                lesson['description'] ??
                                'Start with one small step.',
                            style: const TextStyle(
                                fontSize: 17, height: 1.65, color: navy),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    try {
                                      await widget.api.post(
                                        '/lessons/${lesson['id']}/complete',
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Lesson marked complete!'),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text('Mark complete'),
                                ))),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.api, required this.test});
  final ApiService api;
  final Map<String, dynamic> test;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List questions = List.from(widget.test['questions'] ?? []);
  final answers = <Map<String, dynamic>>[];
  int index = 0;
  int? selected;
  bool checked = false;
  bool correct = false;
  bool busy = false;
  String? explanation;
  String? error;

  Future<void> checkAnswer(int optionId) async {
    setState(() => busy = true);
    try {
      final result = await widget.api.post('/answers/check', {
        'question_id': questions[index]['id'],
        'option_id': optionId,
      });
      if (!mounted) return;
      setState(() {
        error = null;
        checked = true;
        correct = result['correct'];
        explanation = result['explanation'];
        answers.add({
          'question_id': questions[index]['id'],
          'option_id': optionId,
        });
      });
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> next() async {
    if (index + 1 < questions.length) {
      setState(() {
        index++;
        selected = null;
        checked = false;
        explanation = null;
        error = null;
      });
      return;
    }
    setState(() => busy = true);
    try {
      final result = await widget.api.post('/answers/submit', {
        'category': widget.test['category'] ?? 'diagnostic',
        if (widget.test['id'] != null) 'diagnostic_test_id': widget.test['id'],
        'answers': answers,
      });
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Check-in complete'),
            content: Text(
              'You got ${result['score']} out of ${result['total']} correct (${result['percentage']}%). Your progress has been saved.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('This test does not have any questions yet.'),
        ),
      );
    }
    final question = questions[index];
    final options = List.from(question['options'] ?? []);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        title: Text(widget.test['title'] ?? 'Practice Time'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Center(
              child: Text('${index + 1}/${questions.length}',
                  style: const TextStyle(
                      color: navy, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: FilledButton(
                onPressed: busy
                    ? null
                    : checked
                        ? next
                        : selected == null
                            ? null
                            : () => checkAnswer(selected!),
                style: FilledButton.styleFrom(
                  backgroundColor: blue,
                  minimumSize: const Size(double.infinity, 64),
                  padding: const EdgeInsets.all(18),
                ),
                child: Text(
                  busy
                      ? 'Saving...'
                      : checked
                          ? (index + 1 == questions.length
                              ? 'Finish check-in'
                              : 'Next question')
                          : 'Check answer',
                ),
              ))),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                                  'QUESTION ${index + 1} OF ${questions.length}',
                                  style: const TextStyle(
                                      color: muted,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1))),
                          Text(
                              '${((index + 1) / questions.length * 100).round()}%',
                              style: const TextStyle(
                                  color: blue, fontWeight: FontWeight.bold))
                        ]),
                        const SizedBox(height: 16),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (index + 1) / questions.length,
                              minHeight: 9,
                              color: blue,
                              backgroundColor: const Color(0xFFDCE8F5),
                            )),
                        const SizedBox(height: 26),
                        if (question['reading_passage'] is Map) ...[
                          Text(question['reading_passage']['title'] ?? 'Reading passage', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: navy)),
                          const SizedBox(height: 12),
                          Text(question['reading_passage']['body'] ?? '', style: const TextStyle(fontSize: 17, height: 1.6, color: navy)),
                          const SizedBox(height: 24),
                        ],
                        Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: const Color(0xFFEFF8FF),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              question['prompt'] ?? '',
                              style: const TextStyle(
                                fontSize: 21,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            )),
                        const SizedBox(height: 14),
                        if (question['hint'] != null)
                          Container(
                              margin: const EdgeInsets.only(top: 14),
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7E6),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.lightbulb_outline_rounded,
                                        color: Color(0xFFB57A00)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text('Hint: ${question['hint']}',
                                            style: const TextStyle(
                                                color: Color(0xFF70531A))))
                                  ])),
                        const SizedBox(height: 20),
                        ...options.map((option) {
                          final optionId = option['id'] as int;
                          final isSelected = selected == optionId;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OutlinedButton(
                              onPressed: checked || busy
                                  ? null
                                  : () => setState(() => selected = optionId),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? (checked
                                        ? (correct
                                            ? Colors.green.shade50
                                            : Colors.red.shade50)
                                        : paleBlue)
                                    : Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? (checked
                                          ? (correct
                                              ? Colors.green
                                              : Colors.red)
                                          : blue.withValues(alpha: .35))
                                      : line,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 17),
                                alignment: AlignmentDirectional.centerStart,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              child: Row(children: [
                                Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: isSelected
                                        ? blue
                                        : const Color(0xFFCEDFEE),
                                    size: 30),
                                const SizedBox(width: 18),
                                Expanded(
                                    child: Text(
                                        '${option['label']}. ${option['body']}',
                                        style: const TextStyle(
                                            fontSize: 18, color: navy))),
                              ]),
                            ),
                          );
                        }),
                        if (checked)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: correct
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              '${correct ? 'Correct!' : 'Good effort.'} ${explanation ?? ''}',
                              style: TextStyle(
                                color: correct
                                    ? Colors.green.shade900
                                    : Colors.orange.shade900,
                              ),
                            ),
                          ),
                        if (error != null)
                          Text(error!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 20),
                      ]),
                ],
              ))),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.api,
    required this.user,
    required this.onLogout,
    this.journalOnly = false,
    this.onMenu,
  });
  final bool journalOnly;
  final ApiService api;
  final Map<String, dynamic> user;
  final VoidCallback onLogout;
  final VoidCallback? onMenu;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final learned = TextEditingController();
  final goal = TextEditingController();
  late Future<dynamic> journalEntries;
  String mood = 'good';
  DateTime entryDate = DateTime.now();
  late Future<dynamic> progress;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    journalEntries = widget.api.get('/journals');
    progress = widget.api.get('/progress');
  }

  @override
  void dispose() {
    learned.dispose();
    goal.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => saving = true);
    try {
      await widget.api.post('/journals', {
        'entry_date': entryDate.toIso8601String().substring(0, 10),
        'mood': mood,
        'learned': learned.text,
        'next_goal': goal.text,
      });
      if (mounted) {
        setState(() => journalEntries = widget.api.get('/journals'));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reflection saved.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

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
        title: Text(
          widget.journalOnly ? 'Reflection Journal' : 'Profile',
          style: const TextStyle(fontWeight: FontWeight.bold, color: navy),
        ),
      ),
      bottomNavigationBar: widget.journalOnly
          ? SafeArea(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: FilledButton(
                      onPressed: saving ? null : save,
                      child: Text(saving ? 'Saving...' : 'Save reflection'))))
          : null,
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            if (widget.journalOnly) ...[
              const Text('A moment to reflect',
                  style: TextStyle(
                      color: navy, fontSize: 23, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text(
                  'Notice what you learned and choose a small next step.',
                  style: TextStyle(color: muted, fontSize: 15, height: 1.4)),
              const SizedBox(height: 16),
            ],
            if (!widget.journalOnly)
              Card(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(children: [
                        CircleAvatar(
                            radius: 31,
                            backgroundColor: navy,
                            child: Text(
                                (widget.user['name'] ?? 'S')[0]
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: gold,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(width: 16),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(widget.user['name'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: navy)),
                              const SizedBox(height: 4),
                              Text(widget.user['email'] ?? '',
                                  style: const TextStyle(color: muted)),
                              const SizedBox(height: 9),
                              const _LearningPill(
                                  icon: Icons.school_outlined, label: 'Learner')
                            ]))
                      ]))),
            if (!widget.journalOnly) const SizedBox(height: 28),
            if (!widget.journalOnly)
              const Text('Daily reflection',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 19, color: navy)),
            if (!widget.journalOnly) const SizedBox(height: 6),
            if (!widget.journalOnly)
              const Text(
                  'Pause, notice what improved, and choose your next step.',
                  style: TextStyle(color: muted)),
            if (!widget.journalOnly) const SizedBox(height: 14),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: Text(
                  '${DateUtils.isSameDay(entryDate, DateTime.now()) ? 'Today, ' : ''}${MaterialLocalizations.of(context).formatMediumDate(entryDate)}'),
              style: OutlinedButton.styleFrom(
                alignment: AlignmentDirectional.centerStart,
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: Color(0xFFE3ECF6)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: saving
                  ? null
                  : () async {
                      final date = await showDatePicker(
                          context: context,
                          initialDate: entryDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now());
                      if (date != null && mounted) {
                        setState(() => entryDate = date);
                      }
                    },
            ),
            const SizedBox(height: 14),
            Card(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("How did learning feel today?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, color: navy)),
                          const SizedBox(height: 10),
                          LayoutBuilder(
                              builder: (context, constraints) => Wrap(
                                  spacing: 8,
                                  runSpacing: 12,
                                  children: [
                                    (
                                      'great',
                                      Icons.sentiment_very_satisfied_rounded,
                                      'Easy',
                                      green
                                    ),
                                    (
                                      'good',
                                      Icons.sentiment_satisfied_rounded,
                                      'Okay',
                                      gold
                                    ),
                                    (
                                      'okay',
                                      Icons.sentiment_neutral_rounded,
                                      'Challenging',
                                      orange
                                    ),
                                    (
                                      'challenging',
                                      Icons.sentiment_dissatisfied_rounded,
                                      'Difficult',
                                      pink
                                    ),
                                  ]
                                      .map((option) => SizedBox(
                                            width: (constraints.maxWidth -
                                                    (constraints.maxWidth >=
                                                                300 &&
                                                            MediaQuery.textScalerOf(
                                                                        context)
                                                                    .scale(
                                                                        14) <=
                                                                17
                                                        ? 24
                                                        : 8)) /
                                                (constraints.maxWidth >= 300 &&
                                                        MediaQuery.textScalerOf(
                                                                    context)
                                                                .scale(14) <=
                                                            17
                                                    ? 4
                                                    : 2),
                                            child: Semantics(
                                                selected: mood == option.$1,
                                                button: true,
                                                child: InkWell(
                                                  onTap: saving
                                                      ? null
                                                      : () => setState(() =>
                                                          mood = option.$1),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 2),
                                                      decoration: BoxDecoration(
                                                          color: mood == option.$1
                                                              ? option.$4
                                                                  .withValues(
                                                                      alpha:
                                                                          .12)
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          border: Border.all(
                                                              color: mood ==
                                                                      option.$1
                                                                  ? option.$4
                                                                  : Colors
                                                                      .transparent)),
                                                      child: Column(children: [
                                                        Icon(option.$2,
                                                            color: option.$4,
                                                            size: 46),
                                                        const SizedBox(
                                                            height: 6),
                                                        Text(option.$3,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    color: navy,
                                                                    fontSize:
                                                                        12))
                                                      ])),
                                                )),
                                          ))
                                      .toList())),
                          const SizedBox(height: 12),
                          TextField(
                            controller: learned,
                            maxLines: 4,
                            maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: 'What did you learn today?',
                            ),
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder(
                              future: progress,
                              builder: (context, snapshot) {
                                final count = snapshot.hasData
                                    ? (snapshot.data as Map)['today_count']
                                    : null;
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 18),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        color: gold.withValues(alpha: .12),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Today's Achievement",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: navy)),
                                          const SizedBox(height: 12),
                                          Row(children: [
                                            const Icon(Icons.emoji_events,
                                                color: orange, size: 44),
                                            const SizedBox(width: 14),
                                            Expanded(
                                                child: Text(
                                                    count == null
                                                        ? 'Your achievements appear when progress loads.'
                                                        : 'You completed $count activities! Keep going!',
                                                    style: const TextStyle(
                                                        color: navy,
                                                        fontSize: 16)))
                                          ]),
                                        ]));
                              }),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F7FF),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: const Color(0xFFE0EEFC)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(children: [
                                  Icon(Icons.track_changes_rounded,
                                      color: purple, size: 23),
                                  SizedBox(width: 8),
                                  Text('Next Goal',
                                      style: TextStyle(
                                          color: navy,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800)),
                                ]),
                                const SizedBox(height: 6),
                                const Text(
                                    'Choose one small step for your next study session.',
                                    style: TextStyle(color: muted, height: 1.4)),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: goal,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Try another reading activity tomorrow.',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!widget.journalOnly)
                            FilledButton(
                              onPressed: saving ? null : save,
                              child: Text(
                                  saving ? 'Saving...' : 'Save reflection'),
                            ),
                        ]))),
            const SizedBox(height: 20),
            const Text('Recent reflections',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 19, color: navy)),
            FutureBuilder(
              future: journalEntries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                final page = snapshot.data as Map;
                final entries = List.from(page['data'] ?? []);
                if (entries.isEmpty) {
                  return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Your saved reflections will appear here.',
                          style: TextStyle(color: Colors.black54)));
                }
                return Column(
                    children: entries
                        .take(5)
                        .map((entry) => Card(
                              color: Colors.white,
                              child: ListTile(
                                leading:
                                    const Icon(Icons.edit_note, color: navy),
                                title: Text(entry['entry_date'] ?? ''),
                                subtitle: Text([
                                  entry['learned'],
                                  entry['next_goal']
                                ]
                                    .where((value) =>
                                        value != null &&
                                        value.toString().isNotEmpty)
                                    .join('\n')),
                              ),
                            ))
                        .toList());
              },
            ),
            const SizedBox(height: 20),
            if (!widget.journalOnly)
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await widget.api.logout();
                  } catch (_) {
                    // The local token is cleared even if the server cannot be reached.
                  }
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
          ],
        ),
      )));
}

Color learningColor(dynamic category) =>
    switch (category.toString().toLowerCase()) {
      'grammar' => orange,
      'vocabulary' => pink,
      'reading' => purple,
      _ => blue,
    };

IconData learningIcon(dynamic category) =>
    switch (category.toString().toLowerCase()) {
      'grammar' => Icons.article_rounded,
      'vocabulary' => Icons.menu_book_rounded,
      'reading' => Icons.auto_stories_rounded,
      _ => Icons.school_rounded,
    };

class LearningIcon extends StatelessWidget {
  const LearningIcon({super.key, required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: 54,
        height: 58,
        decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: color, size: 36),
      );
}
