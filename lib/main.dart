import 'package:diary/core/theme/my_theme.dart';
import 'package:diary/features/landing.dart';
import 'package:flutter/material.dart';

import 'core/database/firebase_init.dart';
import 'core/di/di.dart';

void main() async{
  setupLocator();
  FirebaseInit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Diary',
      theme: MyThemeClass.lightTheme,
      home: const HomePage(),
    );
  }
}
