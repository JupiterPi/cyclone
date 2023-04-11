import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../util.dart';

class Period {
  const Period({this.id, required this.date});

  final int? id;
  final Date date;

  // serialize

  static Future<void> createTable(Database database) async => await database.execute(
    """CREATE TABLE periods(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT
    );"""
  );

  Period.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        date = Date.parse(map["date"]);

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date.toString(),
  };

  // to string

  @override
  String toString() => "Period{id: $id, date: $date}";
}

abstract class PeriodsService {
  Future<void> insertPeriod(Period period);
  Future<List<Period>> findPeriods();
}

class PeriodsServiceImpl extends PeriodsService {
  PeriodsServiceImpl(this._database);

  final Future<Database> _database;

  @override
  Future<void> insertPeriod(Period period) async
  => (await _database).insert("periods", period.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  @override
  Future<List<Period>> findPeriods() async
  => (await (await _database).query("periods")).map((map) => Period.fromMap(map)).toList();
}

class PeriodsServiceMock extends PeriodsService {
  @override
  Future<void> insertPeriod(Period period) async {}

  @override
  Future<List<Period>> findPeriods() async {
    var data = await rootBundle.loadString("mock_data/mock_periods.txt");
    data = data.replaceAll("(\r\n|\r|\n)", "\n");

    var i = 0;
    return data
        .split("\n")
        .where((line) => line.isNotEmpty)
        .map((line) => Period(id: i++, date: Date.parse(line)))
        .toList();
  }
}