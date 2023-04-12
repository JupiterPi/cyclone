import 'package:cyclone/data/measurements.dart';
import 'package:cyclone/main.dart';

import '../util.dart';

class Weight {
  const Weight({required this.weight, required this.type});

  final double weight;
  final WeightType type;

  @override
  String toString() => "Weight{weight: $weight, $type}";
}

enum WeightType { real, approximated, extrapolated }

abstract class WeightsService {
  Future<List<Weight>> getWeights(Date startDate, int days);
  Future<List<List<Weight>>> getMultipleWeights(List<Date> startDates, int days);
}

const _lookaheadMax = 14;
class WeightsServiceImpl extends WeightsService {
  @override
  Future<List<Weight>> getWeights(Date startDate, int days) async {
    final measurements = await getIt.get<MeasurementsService>().findMeasurements();
    measurements.forEach(print);
    final weights = <Weight>[];
    Measurement? lastRealMeasurement;
    Measurement? nextRealMeasurement;
    var nextRealMeasurementIsExtrapolated = false;
    for (var day = 0; day < days; day++) {
      final date = startDate.addDays(day);
      final matches = measurements.where((measurement) => measurement.date == date);

      if (matches.isEmpty) {
        // delete nextRealMeasurement if expired
        if (nextRealMeasurement != null && nextRealMeasurement.date.toDoubleForComparison() < date.toDoubleForComparison()) nextRealMeasurement = null;

        if (nextRealMeasurement == null) {
          // scan for nextRealMeasurement
          for (var lookaheadDays = 1; true; lookaheadDays++) {
            final lookaheadDate = date.addDays(lookaheadDays);
            final lookaheadMatches = measurements.where((measurement) => measurement.date == lookaheadDate);
            if (lookaheadMatches.isEmpty) {
              if (lookaheadDays > _lookaheadMax) {
                // create flat approximation
                nextRealMeasurement = Measurement(date: date.addDays(_lookaheadMax), weight: (lastRealMeasurement?.weight ?? 0));
                nextRealMeasurementIsExtrapolated = true;
                break;
              } else {
                continue;
              }
            } else {
              nextRealMeasurement = lookaheadMatches.first;
              nextRealMeasurementIsExtrapolated = false;
              break;
            }
          }
        }

        // compute approximated value
        final lastRealComparisonValue = lastRealMeasurement!.date.toDoubleForComparison();
        final percent = ( date.toDoubleForComparison() - lastRealComparisonValue ) / ( nextRealMeasurement.date.toDoubleForComparison() - lastRealComparisonValue );
        final weight = lastRealMeasurement.weight + (nextRealMeasurement.weight - lastRealMeasurement.weight) * percent;
        weights.add(Weight(weight: weight, type: (nextRealMeasurementIsExtrapolated ? WeightType.extrapolated : WeightType.approximated)));

      } else {
        final measurement = matches.first;
        lastRealMeasurement = measurement;
        weights.add(Weight(weight: measurement.weight, type: WeightType.real));
      }
    }
    return weights;
  }

  @override
  Future<List<List<Weight>>> getMultipleWeights(List<Date> startDates, int days) async {
    var weights = <List<Weight>>[];
    for (var startDate in startDates) {
      weights.add(await getWeights(startDate, days));
    }
    return weights;
  }
}
