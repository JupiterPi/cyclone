import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // state

  double get _startWeight => 77.0;
  double _absoluteWeight = 77.0;

  bool _weightSetToday = false;

  // state read

  double get absoluteWeight => _absoluteWeight;
  double get relativeWeight => _absoluteWeight - _startWeight;

  bool get weightSetToday => _weightSetToday;

  // state write

  void setWeight(double weight) {
    _absoluteWeight = weight.toPrecision(1);
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