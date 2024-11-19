import 'package:diary/core/theme/my_theme.dart';
import 'package:diary/features/landing.dart';
import 'package:flutter/material.dart';

import 'core/di/di.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Diary',
      theme: MyThemeClass.lightTheme,
      home: HomePage(),
    );
  }
}
