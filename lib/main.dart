import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CycloneApp());
}

class CycloneApp extends StatelessWidget {
  const CycloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cyclone",
          style: GoogleFonts.crimsonText(fontSize: 28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
  }
}
