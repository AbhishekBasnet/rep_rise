import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0052CC);
  static const Color secondaryGrey = Color(0xFFF4F5F7);

  static const Color appBackgroundColor = Color(0xFFEEF1DA);
  static const Color appContentColor = Color(0xFF1E201E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NataSans',

      scaffoldBackgroundColor: appBackgroundColor,

      textTheme: const TextTheme(
        // BLACK (900) -  huge, impactful headers
        displayLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 57, color: Colors.black),

        // EXTRA BOLD (800) - section headers
        displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 45, color: Colors.black),

        // BOLD (700) - standard Bold font
        headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.black),

        // SEMI BOLD (600) -  App Bar titles or Subtitles
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black),

        // MEDIUM (500) - For buttons or highlighted list items
        labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: primaryBlue),

        // REGULAR (400) - standard reading text
        bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black87),

        // LIGHT (300) - For "de-emphasized" or secondary info
        bodySmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.grey),

        // EXTRA LIGHT (200) - V stylistic/thin use cases
        labelSmall: TextStyle(fontWeight: FontWeight.w200, fontSize: 11, letterSpacing: 0.5),

        // THIN (100) - Specialized artistic text
        displaySmall: TextStyle(fontWeight: FontWeight.w100, fontSize: 36),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: appBackgroundColor,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'NataSans',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: appContentColor,
        ),
        iconTheme: IconThemeData(color: appContentColor),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,

      ),
    );
  }
}
