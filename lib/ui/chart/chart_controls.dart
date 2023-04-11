import 'package:flutter/material.dart';

class ChartControlCard extends StatelessWidget {
  const ChartControlCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: child,
    );
  }
}

class ChartCyclesShownControl extends StatelessWidget {
  const ChartCyclesShownControl({super.key, required this.cyclesShown, required this.addCyclesShown});

  final int cyclesShown;
  final void Function(int) addCyclesShown;

  @override
  Widget build(BuildContext context) {
    return ChartControlCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              "Past cycles shown: ",
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 46,
                    width: 46,
                    child: ElevatedButton(onPressed: () { addCyclesShown(-1); }, child: const Text("-1"))
                ),
                const SizedBox(width: 10),
                Text(
                  "$cyclesShown",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                SizedBox(
                    height: 46,
                    width: 46,
                    child: ElevatedButton(onPressed: () { addCyclesShown(1); }, child: const Text("+1"))
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartDaysShownControl extends StatelessWidget {
  const ChartDaysShownControl({super.key, required this.daysShown, required this.addDaysShown});

  final int daysShown;
  final void Function(int) addDaysShown;

  @override
  Widget build(BuildContext context) {
    return ChartControlCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text("Days shown:"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 46,
                    width: 46,
                    child: ElevatedButton(onPressed: () { addDaysShown(-5); }, child: const Text("-5", style: TextStyle(fontSize: 11)))
                ),
                const SizedBox(width: 10),
                Text(
                  "$daysShown",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                SizedBox(
                    height: 46,
                    width: 46,
                    child: ElevatedButton(onPressed: () { addDaysShown(5); }, child: const Text("+5", style: TextStyle(fontSize: 11)))
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}