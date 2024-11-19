import 'package:flutter/material.dart';
import 'my_light_colors.dart';

class MyElevatedButtonTheme {
  static const myElevatedButtonLightTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(MyLightColors.primary),
    ),
  );
}