import 'package:cyclone/data/measurements.dart';
import 'package:cyclone/data/periods.dart';
import 'package:cyclone/data/weights.dart';
import 'package:cyclone/state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import "package:sqflite/sqflite.dart";

import 'ui/ui-main.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final path = join(await getDatabasesPath(), "cyclone.db");
  //await deleteDatabase(path);
  final db = openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await Measurement.createTable(db);
      await Period.createTable(db);
    },
  );
  getIt.registerLazySingleton<MeasurementsService>(() => MeasurementsServiceMock());
  getIt.registerLazySingleton<PeriodsService>(() => PeriodsServiceMock());

  getIt.registerLazySingleton<WeightsService>(() => WeightsServiceImpl());

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const CycloneApp(),
    )
  );
}
