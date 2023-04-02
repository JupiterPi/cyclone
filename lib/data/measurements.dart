import 'package:cyclone/data/measurements.dart';
import 'package:sqflite/sqflite.dart';

class Measurement {
  final int? id;
  final DateTime date;
  final double weight;

  const Measurement({
    this.id,
    required this.date,
    required this.weight,
  });

  // serialize

  static Future<void> createTable(Database database) async => await database.execute(
    """CREATE TABLE measurements(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      weight REAL
    );"""
  );

  Measurement.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        date = DateTime.parse(map["date"]),
        weight = map["weight"];

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date.toIso8601String(),
    "weight": weight.toStringAsFixed(1),
  };

  // to string

  @override
  String toString() => "Measurement{id: $id, date: $date, weight: $weight}";
}

abstract class MeasurementsService {
  Future<void> insertMeasurement(Measurement measurement);
  Future<List<Measurement>> findMeasurements();
  Future<void> deleteMeasurements();
}

class MeasurementsServiceImpl extends MeasurementsService {
  MeasurementsServiceImpl(this._database);

  final Database _database;

  @override
  Future<void> insertMeasurement(Measurement measurement) async {
    _database.insert("measurements", measurement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Measurement>> findMeasurements() async {
    var measurements = (await _database.query("measurements")).map((map) => Measurement.fromMap(map)).toList();
    print(measurements);
    return measurements;
  }

  @override
  Future<void> deleteMeasurements() async {
    _database.delete("measurements");
  }
}

class MeasurementsServiceEmpty extends MeasurementsService {
  @override
  Future<void> insertMeasurement(Measurement measurement) async {}

  @override
  Future<List<Measurement>> findMeasurements() async => [];

  @override
  Future<void> deleteMeasurements() async {}
}