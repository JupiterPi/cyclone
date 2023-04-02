import 'package:cyclone/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
          ]
      )
    ]
);

class CycloneScaffold extends StatelessWidget {
  final Widget _body;

  const CycloneScaffold({super.key, required Widget body}) : _body = body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Fluctuweight",
            style: GoogleFonts.crimsonText(fontSize: 28)
        ),
      ),
      body: _body,
    );
  }
}
