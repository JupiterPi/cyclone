import 'package:cyclone/util.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

class Measurement {
  final int? id;
  final Date date;
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
        date = Date.parse(map["date"]),
        weight = map["weight"];

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date.toString(),
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

  final Future<Database> _database;

  @override
  Future<void> insertMeasurement(Measurement measurement) async
  => (await _database).insert("measurements", measurement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<List<Measurement>> findMeasurements() async
  => (await (await _database).query("measurements")).map((map) => Measurement.fromMap(map)).toList();

  @override
  Future<void> deleteMeasurements() async
  => (await _database).delete("measurements");
}

class MeasurementsServiceMock extends MeasurementsService {
  @override
  Future<void> insertMeasurement(Measurement measurement) async {}

  @override
  Future<List<Measurement>> findMeasurements() async {
    var data = await rootBundle.loadString("mock_data/mock_measurements.csv");
    data = data.replaceAll("(\r\n|\r|\n)", "\n");

    var i = 1;
    return data
        .split("\n")
        .where((line) => line.isNotEmpty)
        .map((line) => line.split(","))
        .map((parts) => Measurement(
          id: i++,
          date: Date.parse(parts[0]),
          weight: double.parse(parts[1]),
        ))
        .toList();
  }

  @override
  Future<void> deleteMeasurements() async {}
}