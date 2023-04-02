import 'package:cyclone/data/measurements.dart';
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
  openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await Measurement.createTable(db);
    },
    onOpen: (db) {
      print("loaded database");
      getIt.unregister<MeasurementsService>();
      getIt.registerLazySingleton<MeasurementsService>(() => MeasurementsServiceImpl(db));
    },
  ).then((value) => print("loaded database 2"));
  print("opending db");

  getIt.registerLazySingleton<MeasurementsService>(() => MeasurementsServiceEmpty());

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const CycloneApp(),
    )
  );
}
