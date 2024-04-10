import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
  ).copyWith(
    primary: Colors.indigo.shade50,
    secondary: Colors.amber,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 104, 127, 255),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Colors.white54),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
    bodyMedium:
        TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
  ),
  fontFamily: 'Georgia',
);
