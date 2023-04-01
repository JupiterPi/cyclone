import 'package:cyclone/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/ui-main.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const CycloneApp(),
    )
  );
}
