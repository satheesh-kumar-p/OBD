import 'package:flutter/material.dart';

/// GCS dark theme.
/// All colours are exposed as static constants so widgets can reference them
/// without needing a BuildContext.
abstract final class AppTheme {
  // ── Palette
  static const Color background = Color(0xFF0D0F12);
  static const Color surface = Color(0xFF151820);
  static const Color surfaceAlt = Color(0xFF1C2028);
  static const Color surfaceDim = Color(0xFF232830);
  static const Color border = Color(0xFF2C3038);

  static const Color primary = Color(0xFF00BFA5); // teal
  static const Color primaryDim = Color(0xFF00897B);
  static const Color onPrimary = Color(0xFF000000);

  static const Color textPrimary = Color(0xFFE8EAED);
  static const Color textSecond = Color(0xFF9AA0A6);
  static const Color textFaint = Color(0xFF5F6368);

  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFDD835);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // ── Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      surface: surface,
      onSurface: textPrimary,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary, fontSize: 14, height: 1.5),
      bodyMedium: TextStyle(color: textSecond, fontSize: 13, height: 1.5),
      bodySmall: TextStyle(color: textFaint, fontSize: 11, height: 1.4),
      labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8),
      labelMedium:
      TextStyle(color: textSecond, fontSize: 11, letterSpacing: 0.6),
      labelSmall:
      TextStyle(color: textFaint, fontSize: 10, letterSpacing: 0.4),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: border),
      ),
    ),
  );
}
