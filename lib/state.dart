import 'package:cyclone/data/measurements.dart';
import 'package:cyclone/util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppState extends ChangeNotifier {
  MeasurementsService get _measurementsService => GetIt.instance.get<MeasurementsService>();

  AppState() {
    _readStateFromMeasurements();
  }

  // state

  List<Measurement>? _measurements;

  double? _startWeight;
  double? _lastCycleWeight;
  double? _currentWeight;

  bool? _weightSetToday;

  Future<void> _readStateFromMeasurements() async {
    final measurements = await _measurementsService.findMeasurements();
    _measurements = measurements;

    _startWeight = measurements.isEmpty ? 0 : measurements.first.weight;
    _lastCycleWeight = measurements.length >= 2 ? measurements[measurements.length - 2].weight : 0;
    _currentWeight = measurements.isEmpty ? 0 : measurements.last.weight;

    _weightSetToday = measurements.isEmpty ? false : measurements.last.date.isSameDate(DateTime.now());

    notifyListeners();
  }

  // state read

  List<Measurement> get measurements => _measurements ?? [];

  double get startWeight => _startWeight ?? 0;
  double get lastCycleWeight => _lastCycleWeight ?? 0;
  double get currentWeight => _currentWeight ?? 0;

  bool get weightSetToday => _weightSetToday ?? false;

  // state write

  Future<void> setWeight(double weight) async {
    await _measurementsService.insertMeasurement(
        Measurement(date: DateTime.now(), weight: weight.toPrecision(1))
    );
    await _readStateFromMeasurements();
  }

  void resetWeightSetToday() {
    _weightSetToday = false;
    notifyListeners();
  }

  Future<void> clear() async {
    await _measurementsService.deleteMeasurements();
    await _readStateFromMeasurements();
  }
}