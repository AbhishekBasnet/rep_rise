import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF6F61C0);
  static const Color secondaryGrey = Color(0xFFF4F5F7);

  static const Color appBackgroundColor = Color(0xFFEEF1DA);
  static const Color appContentColor = Color(0xFF1E201E);
  static const Color purple = Color(0xFF7F56D9);
  static const Color lavender = Color(0xFFD0BCFF);

  //--------------- Text styles for profile setup ------------------

  static const TextStyle profileSetupHeader = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle profileSetupHeader2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static const TextStyle profileSetupHeader3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static const TextStyle profileSetupSubHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  static const TextStyle profileSetupWheelSelectedText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: purple,
    letterSpacing: 1.5,
  );
  static const TextStyle profileSetupWheelNumberUnselected = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: 1.5,
  );
  static const TextStyle profileSetupWheelNumberSelected = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: purple,
    letterSpacing: 1.5,
  );

  static const TextStyle profileSetupWheelUnitSelected = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
    letterSpacing: 1.5,
  );

  //--------------- Styles for steps screen  ------------------

  static const TextStyle stepsProgressNumber = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
    letterSpacing: 1.5,
  );
  static final stepsCardBoxShadow = BoxShadow(
    color: Colors.grey.withValues(alpha: 0.5),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
  static const TextStyle barGraphXYAxisLabel = TextStyle(color: Colors.grey, fontSize: 12);

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
        labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: primaryPurple),

        bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),

        // REGULAR (400) - standard reading text
        bodyLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black87),

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
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
