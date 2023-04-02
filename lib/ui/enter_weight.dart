import 'package:cyclone/state.dart';
import 'package:cyclone/util.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cyclone_ui.dart';

class EnterWeightDialog extends StatefulWidget {
  const EnterWeightDialog({super.key, required this.initialWeight});

  final double initialWeight;

  @override
  State createState() => _EnterWeightDialogState();
}

class _EnterWeightDialogState extends State<EnterWeightDialog> {
  double _weightDelta = 0.0;

  void _addWeight(double weight) => setState(() {
    _weightDelta += weight;
    if (_effectiveWeight < 0) _weightDelta = -widget.initialWeight;
  });

  void _setWeight(double weight) => setState(() {
    _weightDelta = weight;
  });

  double get _effectiveWeight => widget.initialWeight + _weightDelta;

  @override
  Widget build(BuildContext context) {
    return CycloneOkDialog(
      onOkPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Set today's weight: ${_effectiveWeight.toStringAsFixed(1)} kg"), duration: const Duration(seconds: 1),));

        final state = Provider.of<AppState>(context, listen: false);
        state.setWeight(_effectiveWeight);
        if (_effectiveWeight < state.startWeight - 0.2) {
          showDialog(context: context, builder: (context) => const ShowBadgeDialog());
        }
      },
      children: [
        const Text("Please enter your weight:"),
        Text(
          formatWeightAbsolute(_effectiveWeight),
          style: const TextStyle(fontSize: 50),
        ),
        if(_weightDelta.toPrecision(1) != 0 && widget.initialWeight != 0) Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(formatWeightRelative(_weightDelta)),
        ),
        if (widget.initialWeight == 0) Slider(
          value: _weightDelta,
          onChanged: (valueChanged) {
            _setWeight(valueChanged);
          },
          min: 0,
          max: 130,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 46,
                width: 46,
                child: ElevatedButton(onPressed: () { _addWeight(-1); }, child: const Text("-1"))
            ),
            const SizedBox(width: 10,),
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: () { _addWeight(-0.1); }, child: const Text("-"))
            ),
            const SizedBox(width: 10,),
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: () { _addWeight(0.1); }, child: const Text("+"))
            ),
            const SizedBox(width: 10,),
            SizedBox(
                height: 46,
                width: 46,
                child: ElevatedButton(onPressed: () { _addWeight(1); }, child: const Text("+1"))
            ),
          ],
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class ShowBadgeDialog extends StatelessWidget {
  const ShowBadgeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CycloneOkDialog(
      children: [
        const Text("You earned a badge!"),
        const SizedBox(height: 20,),
        Text(Emojis.rainbow, style: TextStyle(fontSize: 60, shadows: [Shadow(color: Colors.black.withAlpha(100), blurRadius: 10)]),),
      ],
    );
  }
}