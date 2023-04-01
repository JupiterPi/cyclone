import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // state

  final double _lastCycleWeight = 77.0;
  double _currentWeight = 77.0;

  bool _weightSetToday = false;

  // state read

  double get startWeight => 77.5;
  double get lastCycleWeight => _lastCycleWeight;
  double get currentWeight => _currentWeight;

  double get lastCycleWeightDifference => (currentWeight - lastCycleWeight).toPrecision(1);

  bool get weightSetToday => _weightSetToday;

  // state write

  void setWeight(double weight) {
    _currentWeight = weight.toPrecision(1);
    _weightSetToday = true;
    notifyListeners();
  }

  void resetWeightSetToday() {
    _weightSetToday = false;
    notifyListeners();
  }
}

extension Round on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}