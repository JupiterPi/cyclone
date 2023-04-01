import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'cyclone_ui.dart';

class EnterWeightDialog extends StatefulWidget {
  const EnterWeightDialog({super.key});

  @override
  State createState() => _EnterWeightDialogState();
}

class _EnterWeightDialogState extends State<EnterWeightDialog> {
  double _weight = 77;

  void _increaseWeight() => setState(() {
    _weight += 0.1;
  });

  void _decreaseWeight() => setState(() {
    _weight -= 0.1;
  });

  double get _weightDelta => _weight - 77;

  @override
  Widget build(BuildContext context) {
    return CycloneOkDialog(
      onOkPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Set today's weight: ${_weight.toStringAsFixed(1)} kg"), duration: const Duration(seconds: 1),));
        if (_weightDelta < 0) {
          showDialog(context: context, builder: (context) => const ShowBadgeDialog());
        }
      },
      children: [
        const Text("Please enter your weight:"),
        Text(
          "${_weight.toStringAsFixed(1)} kg",
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