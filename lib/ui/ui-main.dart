import 'package:cyclone/ui/chart.dart';
import 'package:cyclone/ui/home.dart';
import 'package:cyclone/ui/measurements_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_schemes.dart';

class CycloneApp extends StatelessWidget {
  const CycloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cyclone',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: GoogleFonts.workSans().fontFamily,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: GoogleFonts.workSans().fontFamily,
      ),
      /*darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: GoogleFonts.workSans().fontFamily,
      ),*/
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
            GoRoute(path: "/measurements", builder: (context, state) => const MeasurementsListPage()),
            GoRoute(path: "/chart", builder: (context, state) => const ChartPage()),
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
