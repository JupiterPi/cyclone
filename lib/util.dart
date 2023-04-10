import 'dart:async';

import 'package:intl/intl.dart';

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

int interpolate(int start, int end, double percent) {
  return ( start + (end-start) * percent ).round();
}

class Date {
  const Date({required this.year, required this.month, required this.day});

  final int year;
  final int month;
  final int day;

  Date.fromDateTime(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day;

  Date.parse(String str) : this.fromDateTime(DateFormat("dd/MM/yyyy").parse(str));

  Date.current() : this.fromDateTime(DateTime.now());

  Date addDays(int days) => Date.fromDateTime(DateTime(year, month, day).add(Duration(days: days)));
  Date subtractDays(int days) => Date.fromDateTime(DateTime(year, month, day).subtract(Duration(days: days)));

  int toDoubleForComparison() => toDateTime().millisecondsSinceEpoch;

  DateTime toDateTime() => DateTime(year, month, day);

  @override
  String toString() => "${day.formatAsLength(2)}/${month.formatAsLength(2)}/$year";

  @override
  bool operator ==(Object other) {
    if (other is! Date) return false;
    return other.year == year && other.month == month && other.day == day;
  }
}

extension FormatIntAsLength on int {
  String formatAsLength(int length) {
    var str = toString();
    while (str.length < length) {
      str = "0$str";
    }
    return str;
  }
}