import 'package:cyclone/data/measurements.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppState extends ChangeNotifier {
  MeasurementsService get _measurements => GetIt.instance.get<MeasurementsService>();

  AppState() {
    _readStateFromMeasurements();
  }

  // state

  double? _startWeight;
  double? _lastCycleWeight;
  double? _currentWeight;

  bool? _weightSetToday;

  Future<void> _readStateFromMeasurements() async {
    final measurements = await _measurements.findMeasurements();

    _startWeight = measurements.first.weight;
    _lastCycleWeight = measurements[measurements.length - 2].weight;
    _currentWeight = measurements.last.weight;

    _weightSetToday = measurements.last.date.isSameDate(DateTime.now());

    notifyListeners();
  }

  // state read

  double get startWeight => _startWeight ?? 0;
  double get lastCycleWeight => _lastCycleWeight ?? 0;
  double get currentWeight => _currentWeight ?? 0;

  bool get weightSetToday => _weightSetToday ?? false;

  // state write

  void setWeight(double weight) async {
    await _measurements.insertMeasurement(
        Measurement(date: DateTime.now(), weight: weight.toPrecision(1))
    );
    await _readStateFromMeasurements();
  }

  void resetWeightSetToday() {
    _weightSetToday = false;
    notifyListeners();
  }
}