import 'package:flutter/material.dart';

final lighttheme = ThemeData(
  useMaterial3: false,
  primaryColor: const Color(0xFF13EC80),
  scaffoldBackgroundColor: const Color(0xFFF6F8F7),
  fontFamily: 'Manrope',
  dividerTheme: DividerThemeData(
    color: Colors.black.withValues(alpha: .8),
    thickness: 1,
    space: 1,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF13EC80),
    brightness: Brightness.light,
  ),
);
final darktheme = ThemeData(
  useMaterial3: false,
  // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ),
  dividerTheme: DividerThemeData(
    color: Colors.white.withValues(alpha: .8),
    thickness: 1,
    space: 1,
  ),
  primaryColor: const Color(0xFF13EC80),
  scaffoldBackgroundColor: const Color(0xFF102219),
  fontFamily: 'Manrope',
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF13EC80),
    brightness: Brightness.dark,
  ),
);
