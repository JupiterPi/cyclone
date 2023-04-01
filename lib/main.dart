import 'package:cyclone/cyclone_ui.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CycloneApp());
}

class CycloneApp extends StatelessWidget {
  const CycloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cyclone',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple, brightness: Brightness.light),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        fontFamily: GoogleFonts.workSans().fontFamily,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => CycloneScaffold(body: child),
      routes: [
        GoRoute(path: "/", builder: (context, state) => const HomePage()),
        GoRoute(path: "/test", builder: (context, state) => const TestPage()),
        GoRoute(
          path: "/enterWeight",
          /*builder: (context, state) => const EnterWeightPage(),*/
          pageBuilder: (context, state) => CustomTransitionPage(
            fullscreenDialog: true,
            child: const EnterWeightPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
              /*return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );*/
            }
          )
        ),
      ]
    )
  ]
);

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Text("Hello there."),
          ElevatedButton(
              onPressed: () { context.go("/"); },
              child: const Text("Back")
          )
        ],
      ),
    );
  }
}

class EnterWeightPage extends StatelessWidget {
  const EnterWeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Text("Enter weight here..."),
          ElevatedButton(
              onPressed: () { context.go("/"); },
              child: const Text("Back"),
          )
        ],
      ),
    );
  }
}

class CycloneScaffold extends StatelessWidget {
  final Widget _body;

  const CycloneScaffold({super.key, required Widget body}) : _body = body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cyclone",
          style: GoogleFonts.crimsonText(fontSize: 28)
        ),
      ),
      body: _body,
    );
  }
}

class EnterWeightDialog extends StatefulWidget {
  const EnterWeightDialog({super.key});

  @override
  State createState() => _EnterWeightDialogState();
}

class _EnterWeightDialogState extends State<EnterWeightDialog> {
  double _weight = 77;

  void _increaseWeight() => setState(() {
    _weight += 0.1;
  });

  void _decreaseWeight() => setState(() {
    _weight -= 0.1;
  });

  double get _weightDelta => _weight - 77;

  @override
  Widget build(BuildContext context) {
    return CycloneOkDialog(
      onOkPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Set today's weight: ${_weight.toStringAsFixed(1)} kg"), duration: const Duration(seconds: 1),));
        if (_weightDelta < 0) {
          showDialog(context: context, builder: (context) => const ShowBadgeDialog());
        }
      },
      children: [
        const Text("Please enter your weight:"),
        Text(
          "${_weight.toStringAsFixed(1)} kg",
          style: const TextStyle(fontSize: 50),
        ),
        if(_weightDelta != 0) Column(
          children: [
            Text(
              "${_weightDelta > 0 ? "+" : "-"} ${_weightDelta.abs().toStringAsFixed(1)} kg",
            ),
            const SizedBox(height: 15,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: _decreaseWeight, child: const Text("-"))
            ),
            const SizedBox(width: 10,),
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: _increaseWeight, child: const Text("+"))
            ),
          ],
        ),
      ],
    );
  }
}

class ShowBadgeDialog extends StatelessWidget {
  const ShowBadgeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CycloneOkDialog(
      children: [
        const Text("You earned a badge!"),
        const SizedBox(height: 20,),
        Text(Emojis.rainbow, style: TextStyle(fontSize: 60, shadows: [Shadow(color: Colors.black.withAlpha(100), blurRadius: 10)]),),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.zero,
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withAlpha(50),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).colorScheme.surface.withAlpha(100),),
            ),
            child: InkWell(
              onTap: () {
                showDialog(context: context, builder: (context) => const EnterWeightDialog());
              },
              borderRadius: BorderRadius.circular(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface.withAlpha(100),),
                  const SizedBox(width: 10,),
                  const Text("Tap here to enter today's weight"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: InkWell(
                  onTap: () {},
                  splashColor: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You've lost weight!",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "-1.5 kg",
                          style: GoogleFonts.crimsonText(fontSize: 70),
                        ),
                        const Text(
                          "compared to last cycle.",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening dashboard..."), duration: Duration(seconds: 1),));
            },
            child: const Text("Dashboard"),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening calendar view..."), duration: Duration(seconds: 1)));
            },
            child: const Text("Calendar View"),
          ),
          ElevatedButton(
            onPressed: () { context.go("/test"); },
            child: const Text("Test Page"),
          ),
        ],
      ),
    );
  }
}
