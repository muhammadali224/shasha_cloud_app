import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../core/constant/box_key.dart';
import '../../core/utils/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit._internal() : super(_arabicTheme);
  static final ThemeCubit _instance = ThemeCubit._internal();

  factory ThemeCubit() {
    return _instance;
  }

  static final ThemeData _arabicTheme = ThemeData(
      colorScheme: MaterialTheme.lightScheme(),
      useMaterial3: true,
      brightness: MaterialTheme.lightScheme().brightness,
      scaffoldBackgroundColor: MaterialTheme.lightScheme().surface,
      canvasColor: MaterialTheme.lightScheme().surface,
      fontFamily: 'Almarai',
      appBarTheme: const AppBarTheme(centerTitle: true));

  static final ThemeData _englishTheme = ThemeData(
      colorScheme: MaterialTheme.lightScheme(),
      useMaterial3: true,
      brightness: MaterialTheme.lightScheme().brightness,
      scaffoldBackgroundColor: MaterialTheme.lightScheme().surface,
      canvasColor: MaterialTheme.lightScheme().surface,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(centerTitle: true));
  static final ThemeData _darkArabicTheme = ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MaterialTheme.darkScheme().surface,
    canvasColor: MaterialTheme.darkScheme().surface,
    fontFamily: 'Almarai',
    textTheme: const TextTheme().apply(
        displayColor: Colors.white,
        bodyColor: Colors.white,
        decorationColor: Colors.white),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static final ThemeData _darkEnglishTheme = ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MaterialTheme.darkScheme().surface,
    canvasColor: MaterialTheme.darkScheme().surface,
    fontFamily: 'Poppins',
    textTheme: const TextTheme().apply(
        displayColor: Colors.white,
        bodyColor: Colors.white,
        decorationColor: Colors.white),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  void updateTheme({required Locale locale, required bool isDarkMode}) {
    if (isDarkMode) {
      if (locale.languageCode == BoxKey.arLanguage) {
        emit(_darkArabicTheme);
      } else {
        emit(_darkEnglishTheme);
      }
    } else {
      if (locale.languageCode == BoxKey.arLanguage) {
        emit(_arabicTheme);
      } else {
        emit(_englishTheme);
      }
    }
  }
}
