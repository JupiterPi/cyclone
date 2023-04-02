import 'package:cyclone/state.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

  void _increaseWeight() => setState(() {
    _weightDelta += 0.1;
  });

  void _decreaseWeight() => setState(() {
    _weightDelta -= 0.1;
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
          "${_effectiveWeight.toStringAsFixed(1)} kg",
          style: const TextStyle(fontSize: 50),
        ),
        if(_weightDelta != 0) Column(
          children: [
            Text(
              "${_weightDelta > 0 ? "+" : "-"} ${_weightDelta.abs().toStringAsFixed(1)} kg",
            ),
            const SizedBox(height: 15,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: _decreaseWeight, child: const Text("-"))
            ),
            const SizedBox(width: 10,),
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(onPressed: _increaseWeight, child: const Text("+"))
            ),
          ],
        ),
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