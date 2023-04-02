import 'package:cyclone/state.dart';
import 'package:cyclone/ui/cyclone_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MeasurementsListPage extends StatelessWidget {
  const MeasurementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Consumer<AppState>(
          builder: (context, state, child) => Column(
            children: state.measurements.isNotEmpty
                ? state.measurements.map((measurement) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CycloneCard(
                      child: Text("Measurement: ${measurement.date}, ${measurement.weight}"),
                    ),
                  )).toList()
                : [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 5),
                    child: Text("No data"),
                  )
                ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Provider.of<AppState>(context, listen: false).clear();
                },
                child: const Text("Clear All")
            ),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {
                  context.go("/");
                },
                child: const Text("Back")
            ),
          ]
        ),
      ],
    );
  }
}