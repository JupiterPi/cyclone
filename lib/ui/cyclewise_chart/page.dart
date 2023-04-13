import 'package:flutter/material.dart';

class CyclewiseChartPage extends StatelessWidget {
  const CyclewiseChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            const Text("Hello there"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        )
    );
  }
}