import 'package:blogexplorer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read(_key) ?? false;
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_key, isDarkMode.value);
  }
}

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Constants.darkSecondary,
        brightness: Brightness.dark,
        primary: Constants.lightPrimary,
        secondary: Constants.darkSecondary,
      ),
      scaffoldBackgroundColor: Constants.darkPrimary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Constants.lightPrimary)),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Constants.darkBorderColor,
          contentTextStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Constants.darkTextColor,
              fontStyle: FontStyle.normal)));

  static final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Constants.lightSecondary,
        brightness: Brightness.light,
        primary: Constants.darkPrimary,
        secondary: Constants.lightSecondary,
      ),
      scaffoldBackgroundColor: Constants.lightPrimary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Constants.darkPrimary)),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Constants.lightBorderColor,
          contentTextStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Constants.lightTextColor,
              fontStyle: FontStyle.normal)));
}
