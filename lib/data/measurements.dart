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

class MeasurementsService {
  MeasurementsService(this._database);

  final Future<Database> _database;

  Future<void> insertMeasurement(Measurement measurement) async
  => (await _database).insert("measurements", measurement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Measurement>> findMeasurements() async
  => (await (await _database).query("measurements")).map((map) => Measurement.fromMap(map)).toList();

  Future<void> deleteMeasurements() async
  => (await _database).delete("measurements");
}