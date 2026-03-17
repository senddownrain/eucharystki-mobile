import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1867C0);

  static ThemeData light(String fontFamily) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      brightness: Brightness.light,
    );
    return base.copyWith(textTheme: _applyFont(base.textTheme, fontFamily));
  }

  static ThemeData dark(String fontFamily) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      brightness: Brightness.dark,
    );
    return base.copyWith(textTheme: _applyFont(base.textTheme, fontFamily));
  }

  static TextTheme _applyFont(TextTheme textTheme, String fontFamily) {
    switch (fontFamily) {
      case 'Kurale':
        return GoogleFonts.kuraleTextTheme(textTheme);
      case 'OldStandardTT':
        return GoogleFonts.oldStandardTtTextTheme(textTheme);
      case 'YesevaOne':
        return GoogleFonts.yesevaOneTextTheme(textTheme);
      case 'Comfortaa':
        return GoogleFonts.comfortaaTextTheme(textTheme);
      case 'Pacifico':
        return GoogleFonts.pacificoTextTheme(textTheme);
      default:
        return textTheme;
    }
  }
}
