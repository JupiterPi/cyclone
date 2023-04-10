import 'package:cyclone/data/weights.dart';
import 'package:cyclone/main.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  static Future<List<List<Weight>>> _getMultipleWeights(List<Date> startDates, int days) async {
    var weights = <List<Weight>>[];
    for (var startDate in startDates) {
      weights.add(await getIt.get<WeightsService>().getWeights(startDate, days));
    }
    return weights;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            FutureBuilder(
                future: _getMultipleWeights([
                  const Date(year: 2023, month: 02, day: 01),
                  const Date(year: 2023, month: 02, day: 15),
                  const Date(year: 2023, month: 03, day: 01),
                  const Date(year: 2023, month: 03, day: 15),
                  const Date(year: 2023, month: 04, day: 01),
                ], 10), // 82
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {

                    return const Text("No data...");

                  } else {

                    final weights = snapshot.data!;
                    return ChartCard(data: weights, daysStep: 5);

                  }
                }
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () { context.go("/"); }, child: const Text("Back")),
          ],
        )
    );
  }
}