import 'package:cyclone/data/measurements.dart';
import 'package:cyclone/state.dart';
import 'package:cyclone/ui/cyclone_ui.dart';
import 'package:cyclone/ui/enter_weight.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Consumer<AppState>(
          builder: (context, state, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!state.weightSetToday) const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: EnterWeightButton(),
              ),
              const AtAGlanceCard(),
              const SizedBox(height: 15),
              const BaseValuesCard(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
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
                    child: const Text("Calendar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening measurements view..."), duration: Duration(seconds: 1)));
                    },
                    child: const Text("Measurements"),
                  ),
                ],
              ),

              // for debugging
              const SizedBox(height: 50),
              CycloneCard(
                child: Consumer<AppState>(
                  builder: (context, state, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start weight: ${state.startWeight}"),
                      Text("Last cycle's weight: ${state.lastCycleWeight}"),
                      Text("Current weight: ${state.currentWeight}"),
                      Text("The weight ${state.weightSetToday ? "was" : "wasn't"} set today."),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: GetIt.instance.get<MeasurementsService>().findMeasurements(),
                        builder: (context, snapshot) => Column(
                          children: snapshot.hasData
                              ? snapshot.data!.map((measurement) => Text(measurement.toString())).toList()
                              : [ const Text("No data...") ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (state.weightSetToday) ElevatedButton(
                onPressed: () {
                  Provider.of<AppState>(context, listen: false).resetWeightSetToday();
                },
                child: const Text("(reset button)"),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EnterWeightButton extends StatelessWidget {
  const EnterWeightButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class AtAGlanceCard extends StatelessWidget {
  const AtAGlanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        var lastCycleWeightDifference = (state.currentWeight - state.lastCycleWeight).toPrecision(1);
        return CycloneCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (lastCycleWeightDifference > 0 ? "You've gained weight:" : (lastCycleWeightDifference < 0 ? "You've lost weight!" : "Your weight hasn't changed")),
                style: const TextStyle(fontSize: 20),
              ),
              if (lastCycleWeightDifference != 0) Text(
                formatWeightRelative(lastCycleWeightDifference),
                style: GoogleFonts.crimsonText(fontSize: 70),
              ),
              const Text(
                "compared to last cycle.",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class BaseValuesCard extends StatelessWidget {
  const BaseValuesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      child: Consumer<AppState>(
          builder: (context, state, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "At a glance:",
                style: TextStyle(fontSize: 20),
              ),
              BaseValueTextElement(
                value: formatWeightAbsolute(state.currentWeight),
                textBefore: "Your current weight is",
                textAfter: ",",
              ),
              BaseValueTextElement(
                value: formatWeightRelative(state.currentWeight - state.startWeight),
                textAfter: "compared to your starting weight.",
              ),
              BaseValueTextElement(
                value: formatWeightAbsolute(state.lastCycleWeight),
                textBefore: "Last cycle's weight was",
                textAfter: ".",
              ),
            ]
          )
      ),
    );
  }
}

class BaseValueTextElement extends StatelessWidget {
  const BaseValueTextElement({super.key, this.textBefore, required this.value, this.textAfter});

  final String? textBefore;
  final String value;
  final String? textAfter;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (textBefore != null) Padding(
          padding: const EdgeInsets.only(right: 7, bottom: 6),
          child: Text(textBefore!),
        ),
        Text(
          value,
          style: GoogleFonts.crimsonText(fontSize: 25),
        ),
        if (textAfter != null) Padding(
          padding: const EdgeInsets.only(left: 7, bottom: 6),
          child: Text(textAfter!),
        ),
      ],
    );
  }
}