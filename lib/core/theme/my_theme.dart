import 'package:flutter/material.dart';
import 'elevated_button_theme.dart';
import 'input_decoration.dart';
import 'my_dark_colors.dart';
import 'my_light_colors.dart';
import 'text_theme.dart';

class MyThemeClass {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      foregroundColor: MyLightColors.surface,
      color: MyLightColors.primary,
    ),
    colorScheme: const ColorScheme.light(
      primary: MyLightColors.primary,
      secondary: MyLightColors.secondary,
      surface: MyLightColors.surface,
      shadow: MyLightColors.shadow,
    ),
    textTheme: MyTextTheme.lightTextTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.myElevatedButtonLightTheme,
    inputDecorationTheme: MyInputDecorationTheme.inputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: MyDarkColors.primary,
      secondary: MyDarkColors.secondary,
      surface: MyDarkColors.surface,
      shadow: MyDarkColors.shadow,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: MyLightColors.secondary,
    ),
    textTheme: MyTextTheme.darkTextTheme,
    inputDecorationTheme: MyInputDecorationTheme.inputDecorationTheme,
  );
}