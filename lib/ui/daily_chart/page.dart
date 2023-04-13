import 'package:cyclone/ui/daily_chart/chart.dart';
import 'package:flutter/material.dart';

class DailyChartPage extends StatelessWidget {
  const DailyChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            const ChartCard(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        )
    );
  }
}