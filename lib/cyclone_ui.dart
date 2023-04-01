import 'package:flutter/material.dart';

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