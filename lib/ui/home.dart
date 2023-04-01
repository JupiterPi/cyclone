import 'package:cyclone/state.dart';
import 'package:cyclone/ui/cyclone_ui.dart';
import 'package:cyclone/ui/enter_weight.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Consumer<AppState>(
        builder: (context, state, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!state.weightSetToday) Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
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
                    var currentWeight = Provider.of<AppState>(context, listen: false).currentWeight;
                    showDialog(context: context, builder: (context) => EnterWeightDialog(initialWeight: currentWeight,));
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
            ),
            CycloneCard(
              child: Consumer<AppState>(
                builder: (context, state, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (state.lastCycleWeightDifference > 0 ? "You've gained weight:" : (state.lastCycleWeightDifference < 0 ? "You've lost weight!" : "Your weight hasn't changed")),
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (state.lastCycleWeightDifference != 0) Text(
                        "${state.lastCycleWeightDifference > 0 ? "+" : "-"} ${state.lastCycleWeightDifference.abs().toStringAsFixed(1)} kg",
                        style: GoogleFonts.crimsonText(fontSize: 70),
                      ),
                      const Text(
                        "compared to last cycle.",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  );
                }
              ),
            ),
            const SizedBox(height: 8),
            CycloneCard(
              child: Consumer<AppState>(
                builder: (context, state, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start weight: ${state.startWeight}"),
                    Text("Last cycle's weight: ${state.lastCycleWeight}"),
                    Text("Current weight: ${state.currentWeight}"),
                    Text("Difference between last cycle's and current weight: ${state.lastCycleWeightDifference}"),
                    Text("The weight ${state.weightSetToday ? "was" : "wasn't"} set today."),
                  ],
                ),
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
            if (state.weightSetToday) ElevatedButton(
              onPressed: () {
                Provider.of<AppState>(context, listen: false).resetWeightSetToday();
              },
              child: const Text("(reset button)"),
            ),
          ],
        ),
      ),
    );
  }
}