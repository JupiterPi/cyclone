import 'package:charts_painter/chart.dart';
import 'package:cyclone/data/weights.dart';
import 'package:cyclone/ui/chart/chart_controls.dart';
import 'package:cyclone/ui/ui-main.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';

import '../../data/periods.dart';
import '../../main.dart';
import 'colors_legend.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({super.key});

  @override
  State createState() => _CartCardState();
}

class _CartCardState extends State<ChartCard> {
  int _cyclesShown = 2;
  void _addCyclesShown(int delta) => setState(() {
    _cyclesShown = _cyclesShown + delta;
    if (_cyclesShown < 1) _cyclesShown = 1;
    if (_cyclesShown > 5) _cyclesShown = 5;
  });

  int _daysShown = 10;
  void _addDaysShown(int delta) => setState(() {
    _daysShown = _daysShown + delta;
    if (_daysShown < 5) _daysShown = 5;
    if (_daysShown > 30) _daysShown = 30;
  });

  static Future<List<List<Weight>>> _getWeights(int cyclesShown, int daysShown) async {
    final periods = await getIt.get<PeriodsService>().findPeriods();
    final startDates = <Date>[];
    for (int i = 1; i <= cyclesShown; i++) {
      final lastPeriod = periods.removeLast();
      startDates.add(lastPeriod.date);
    }
    return getIt.get<WeightsService>().getMultipleWeights(startDates.reversed.toList(), daysShown);
  }

  @override
  Widget build(BuildContext context) {
    final future = _getWeights(_cyclesShown, _daysShown);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
          future: future, // 82
          builder: (context, snapshot) {
            if (!snapshot.hasData) {

              return const Text("No data...");

            } else {

              final weights = snapshot.data!;
              return ChartCardContent(
                data: weights,
                cyclesShown: _cyclesShown,
                addCyclesShown: _addCyclesShown,
                daysShown: _daysShown,
                addDaysShown: _addDaysShown,
              );

            }
          },
        ),
      ),
    );
  }
}

class ChartCardContent extends StatefulWidget {
  const ChartCardContent({super.key, required this.data, required this.cyclesShown, required this.addCyclesShown, required this.daysShown, required this.addDaysShown});

  // latest cycle is last element
  final List<List<Weight>> data;

  final int cyclesShown;
  final void Function(int) addCyclesShown;

  final int daysShown;
  final void Function(int) addDaysShown;

  @override
  State createState() => _ChartCardContentState();
}

class _ChartCardContentState extends State<ChartCardContent> {
  int? _listSelected;
  void _setListSelected(int? index) => setState(() {
    _listSelected = index;
  });

  @override
  Widget build(BuildContext context) {
    final chartItems = widget.data.map((list) => list.map((e) => ChartItem(e.weight *1000)).toList()).toList();

    var min = 130.0;
    var max = 0.0;
    for (final list in widget.data) {
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

    var verticalAxisStep = 5;
    if (widget.data.first.length <= 10) verticalAxisStep = 2;
    if (widget.data.first.length <= 5) verticalAxisStep = 1;
    verticalAxisLabel(int i) {
      if (i == 0) return "P";
      return "+$i";
    }

    listColorAlpha(int i) {
      final length = widget.data.length - 1;
      if (length == 0) return 255;
      return interpolate(255, 100, ( (length-i) / length ));
    }
    listGreyAlpha(int i) {
      return (listColorAlpha(i) * 0.3).round();
    }
    listColor(int i) {
      if (i == widget.data.length - 1) return const Color(0xffd5116a);
      return Theme.of(context).colorScheme.primary.withAlpha(listColorAlpha(i));
    }

    applyAlphaForSelection(int i, Color color) {
      final modifier = (_listSelected != null && _listSelected != i) ? 0.2 : 1.0;
      if (_listSelected == i) return color.withAlpha(255);
      return color.withAlpha((color.alpha * modifier).round());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chart(
          state: ChartState(
            data: chartData,
            itemOptions: BubbleItemOptions(maxBarWidth: 0),
            foregroundDecorations: [
              for (var i = 0; i < widget.data.length; i++) SparkLineDecoration(
                listIndex: i,
                lineWidth: 2,
                gradient: LinearGradient(colors: [
                  for (final weight in widget.data[i]) applyAlphaForSelection(i,
                      weight.type == WeightType.real ? listColor(i) : (
                          weight.type == WeightType.approximated
                              ? Colors.black.withAlpha(listGreyAlpha(i))
                              : Colors.white.withAlpha(0)
                      )
                  )
                ]),
                smoothPoints: true,
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
          "P = Period, +.. = .. days after period",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ChartCyclesShownControl(
                  cyclesShown: widget.cyclesShown,
                  addCyclesShown: widget.addCyclesShown,
                ),
                ChartDaysShownControl(
                  daysShown: widget.daysShown,
                  addDaysShown: widget.addDaysShown,
                ),
              ],
            ),
            ChartColorsLegend(
              length: widget.data.length,
              indexSelected: _listSelected,
              listColor: listColor,
              onSelect: _setListSelected,
            ),
          ],
        ),
      ],
    );
  }
}