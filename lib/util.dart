import 'dart:async';

extension Round on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

// https://stackoverflow.com/a/70890906/13164753
extension FutureExtension<T> on Future<T> {
  /// Checks if the future has returned a value, using a Completer.
  bool isCompleted() {
    final completer = Completer<T>();
    then(completer.complete).catchError(completer.completeError);
    return completer.isCompleted;
  }
}

// https://stackoverflow.com/a/60782895/13164753
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}