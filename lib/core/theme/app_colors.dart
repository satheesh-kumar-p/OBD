import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color healthy = Color(0xFF00FF66);
  static const Color faulty = Color(0xFFFF3B3B);
  static const Color degraded = Colors.orangeAccent;
  static const Color unknown = Color(0xFF93A9B5);
  
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1C1F26);
  static const Color border = Colors.white10;
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textDisabled = Colors.white24;

  static const Color accent = Color(0xFF2FD0FF);
  static const Color accentVariant = Colors.cyanAccent;
  static const Color steel = Color(0xFF93A9B5);

  // Specific status colors if they differ from general ones
  static const Color warning = Colors.orangeAccent;
  static const Color danger = Color(0xFFFF3B3B);
  static const Color success = Color(0xFF00FF66);

  // Battery specific colors
  static const Color batteryEmpty = Colors.white12;
  static const Color batteryText = Colors.white;
}
