import 'package:charts_painter/chart.dart';
import 'package:cyclone/data/weights.dart';
import 'package:cyclone/ui/ui-main.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';

import 'colors_legend.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({super.key, required this.data, required this.daysStep});

  // latest cycle is last element
  final List<List<Weight>> data;
  final int daysStep;

  @override
  Widget build(BuildContext context) {
    final chartItems = data.map((list) => list.map((e) => ChartItem(e.weight *1000)).toList()).toList();

    var min = 130.0;
    var max = 0.0;
    for (final list in data) {
      for (final weight in list) {
        if (weight.weight < min) min = weight.weight;
        if (weight.weight > max) max = weight.weight;
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

    listColorAlpha(int i) {
      final length = data.length - 1;
      return interpolate(255, 100, ( (length-i) / length ));
    }
    listGreyAlpha(int i) {
      return (listColorAlpha(i) * 0.5).round();
    }
    listColor(int i) {
      if (i == data.length - 1) return const Color(0xffd5116a);
      return Theme.of(context).colorScheme.primary.withAlpha(listColorAlpha(i));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chart(
              state: ChartState(
                data: chartData,
                itemOptions: BubbleItemOptions(maxBarWidth: 0),
                foregroundDecorations: [
                  for (var i = 0; i < data.length; i++) SparkLineDecoration(
                    listIndex: i,
                    lineWidth: 2,
                    lineColor: listColor(i),
                    gradient: LinearGradient(colors: [
                      for (final weight in data[i]) weight.isApproximated ? Colors.black.withAlpha(listGreyAlpha(i)) : listColor(i)
                    ]),
                  ),
                ],
                backgroundDecorations: [
                  HorizontalAxisDecoration(
                    axisStep: 0.5 *1000,
                    showValues: true,
                    endWithChart: true,
                    axisValue: (value) => "${(value /1000).toStringAsFixed(1)} kg",
                    legendFontStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 13,
                      fontFamily: textFont().fontFamily,
                    ),
                  ),
                  VerticalAxisDecoration(
                    axisStep: verticalAxisStep.toDouble(),
                    showValues: true,
                    valueFromIndex: verticalAxisLabel,
                    endWithChart: true,
                    legendFontStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: textFont().fontFamily,
                    ),
                    valuesAlign: TextAlign.left,
                  ),
                ],
              ),
              height: 200,
              width: 500,
            ),
            const SizedBox(height: 5),
            const Text(
              "P = Period, +5 = 5 days after period",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 15),
            ChartColorsLegend(
              length: data.length,
              indexSelected: 4,
              listColor: listColor,
              onSelect: (index){},
            ),
          ],
        ),
      ),
    );
  }
}