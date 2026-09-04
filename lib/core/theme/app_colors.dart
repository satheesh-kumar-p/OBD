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
  static const Color batteryGreenColor = Color(0xFF1E7D25);


  //Battery percentage colors hex code
  static const Color batteryFullGreen = Color(0xFF2ECC71);     // 80% - 100%
  static const Color batteryStandardGreen = Color(0xFF4CD964); // 20% - 79%
  static const Color batteryWarning = Color(0xFFFFCC00);       // 10% - 19%
  static const Color batteryCritical = Color(0xFFFF3B30);
}
