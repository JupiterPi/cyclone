import 'package:cyclone/ui/enter_weight.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
        ],
      ),
    );
  }
}