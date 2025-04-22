import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.mainColor),
    useMaterial3: true,
    fontFamily: 'Almarai',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
    ),
  );
}
