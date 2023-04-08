import 'package:charts_painter/chart.dart';
import 'package:cyclone/main.dart';
import 'package:cyclone/ui/cyclone_ui.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/measurements.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  static Future<List<Measurement>> _getMeasurements(Date startDate, int days) async {
    final measurements = await getIt.get<MeasurementsService>().findMeasurements();
    var resultingMeasurements = <Measurement>[];
    for (int daysDifference = 0; daysDifference < days; daysDifference++) {
      final date = startDate.addDays(daysDifference);
      final matches = measurements.where((measurement) => measurement.date == date).toList();
      if (matches.isNotEmpty) resultingMeasurements.add(matches[0]);
    }
    return resultingMeasurements;
  }

  static Future<List<List<Measurement>>> _getMultipleMeasurements(List<Date> startDates, int days) async {
    var measurements = <List<Measurement>>[];
    for (var startDate in startDates) {
      measurements.add(await _getMeasurements(startDate, days));
    }
    return measurements;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            FutureBuilder(
                future: _getMultipleMeasurements([
                  const Date(year: 2023, month: 02, day: 01),
                  const Date(year: 2023, month: 03, day: 01),
                  const Date(year: 2023, month: 04, day: 01),
                ], 30), // 82
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {

                    return const Text("No data...");

                  } else {

                    final measurements = snapshot.data!;
                    final data = measurements.map((list) => list.map((e) => e.weight).toList()).toList();
                    return ChartCard(data: data, daysStep: 5);

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

class ChartCard extends StatelessWidget {
  const ChartCard({super.key, required this.data, required this.daysStep});

  // latest cycle is last element
  final List<List<double>> data;
  final int daysStep;

  @override
  Widget build(BuildContext context) {
    final chartItems = data.map((list) => list.map((e) => ChartItem(e *1000)).toList()).toList();

    var min = 130.0;
    var max = 0.0;
    for (final list in data) {
      for (final weight in list) {
        if (weight < min) min = weight;
        if (weight > max) max = weight;
      }
    }

    final chartData = ChartData(
      chartItems,
      dataStrategy: const DefaultDataStrategy(stackMultipleValues: false),
      axisMin: min *1000,
      axisMax: max *1000,
    );

    const verticalAxisStep = 5;
    verticalAxisLabel(int i) {
      if (i == 0) return "P";
      return "+$i";
    }

    legendListLabel(int i, int length) {
      final negativeIndex = length-1 - i;
      switch (negativeIndex) {
        case 0: return "Current cycle";
        case 1: return "Last cycle";
        case 2: return "2nd last cycle";
        case 3: return "3rd last cycle";
        default: return "${negativeIndex}th last cycle";
      }
    }

    listColor(int i) {
      if (i == data.length - 1) return Theme.of(context).colorScheme.error;
      final length = data.length - 1;
      return Theme.of(context).colorScheme.primary.withAlpha(interpolate(255, 100, ( (length-i) / length )));
    }

    return Column(
      children: [
        CycloneCard(
          child: Chart(
            state: ChartState(
              data: chartData,
              itemOptions: BubbleItemOptions(maxBarWidth: 0),
              foregroundDecorations: [
                for (var i = 0; i < data.length; i++) SparkLineDecoration(
                  listIndex: i,
                  lineWidth: 2,
                  lineColor: listColor(i),
                ),
              ],
              backgroundDecorations: [
                HorizontalAxisDecoration(
                  axisStep: 0.5 *1000,
                  showValues: true,
                  axisValue: (value) => "${(value /1000).toStringAsFixed(1)} kg",
                  legendFontStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                ),
                VerticalAxisDecoration(
                  axisStep: verticalAxisStep.toDouble(),
                  showValues: true,
                  valueFromIndex: verticalAxisLabel,
                  endWithChart: true,
                  legendFontStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  valuesAlign: TextAlign.left,
                ),
              ],
            ),
            height: 200,
            width: 500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: const [
            SizedBox(width: 10),
            Text(
              "P = Period, +5 = 5 days after period",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 20,
          runSpacing: 5,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < data.length; i++) Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listColor(i),
                  ),
                  child: null,
                ),
                const SizedBox(width: 5),
                Text(legendListLabel(i, data.length)),
              ],
            ),
          ].reversed.toList(),
        ),
      ],
    );
  }
}