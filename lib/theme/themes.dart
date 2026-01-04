import 'package:flutter/material.dart';

const LinearGradient lightAppBarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF6F8F7), // scaffoldBackgroundColor
    Color(0xFFE8FDF3), // very light green tint
  ],
);
const LinearGradient darkAppBarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF102219), // scaffoldBackgroundColor
    Color(0xFF133528), // green-tinted dark
  ],
);
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
// final darktheme = ThemeData(
//   useMaterial3: false,
//   // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ),
//   dividerTheme: DividerThemeData(
//     color: Colors.white.withValues(alpha: .8),
//     thickness: 1,
//     space: 1,
//   ),
//   primaryColor: const Color(0xFF13EC80),
//   scaffoldBackgroundColor: const Color(0xFF102219),
//   fontFamily: 'Manrope',
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: const Color(0xFF13EC80),
//     brightness: Brightness.dark,
//   ),
// );
final darktheme=ThemeData(
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