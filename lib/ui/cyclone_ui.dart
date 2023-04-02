import 'package:flutter/material.dart';

class CycloneCard extends StatelessWidget {
  const CycloneCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        child: InkWell(
          onTap: () { onTap?.call(); },
          splashColor: Theme.of(context).colorScheme.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: child
          ),
        )
      ),
    );
  }
}

class CycloneDialog extends StatelessWidget {
  const CycloneDialog({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class CycloneOkDialog extends StatelessWidget {
  const CycloneOkDialog({super.key, this.onOkPressed, required this.children});

  final VoidCallback? onOkPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CycloneDialog(
      children: [
        ...children,
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);
              onOkPressed?.call();
            },
            child: const Text("Ok"),
          ),
        ),
      ],
    );
  }
}

String formatWeightAbsolute(double weight) => "${weight.toStringAsFixed(1)} kg";
String formatWeightRelative(double weight) => "${weight > 0 ? "+" : "-"} ${weight.abs().toStringAsFixed(1)} kg";