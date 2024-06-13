import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    //* BACKGROUND and SURFACE
    surface: Color(0xFFF8F9FF),
    onSurface: Color(0xFF191C20),
    background: Color(0xFFE1E2E8),
    onBackground: Color(0xFF191C20),

    //* PRIMARY
    primary: Color(0xFF116682),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFBDE9FF),
    onPrimaryContainer: Color(0XFF001F2A),

    //* SECONDARY
    secondary: Color(0xFF535F70),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD7E3F7),
    onSecondaryContainer: Color(0xFF101C2B),

    //* TERTIARY
    tertiary: Color(0xFF6B5778),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF2DAFF),
    onTertiaryContainer: Color(0xFF251431),

    //* ERROR
    error: Color(0XFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0XFF410002),
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    enableFeedback: false,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Color(0XFF001F2A),
    unselectedItemColor: Color(0xFF116682),
    selectedIconTheme: IconThemeData(
      color: Color(0XFF001F2A),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color(0xFF116682),
    ),
    selectedLabelStyle: TextStyle(
      color: Color(0XFF001F2A),
    ),
    unselectedLabelStyle: TextStyle(
      color: Color(0xFF116682),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    //* BACKGROUND and SURFACE
    surface: Color(0xFF32353A),
    onSurface: Color(0xFFE1E2E8),
    background: Color(0xFF111418),
    onBackground: Color(0xFFE1E2E8),

    //* PRIMARY
    primary: Color(0xFFA0CAFD),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF194975),
    onPrimaryContainer: Color(0XFFD1E4FF),

    //* SECONDARY
    secondary: Color(0xFFBBC7DB),
    onSecondary: Color(0xFF253140),
    secondaryContainer: Color(0xFF3B4858),
    onSecondaryContainer: Color(0xFFD7E3F7),

    //* TERTIARY
    tertiary: Color(0xFFD6BEE4),
    onTertiary: Color(0xFF3B2948),
    tertiaryContainer: Color(0xFF523F5F),
    onTertiaryContainer: Color(0xFFF2DAFF),

    //* ERROR
    error: Color(0XFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0XFFFFDAD6),
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Color(0xFF116682),
    unselectedItemColor: Color(0xFF253140),
    selectedIconTheme: IconThemeData(
      color: Color(0xFF116682),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color(0xFF253140),
    ),
    selectedLabelStyle: TextStyle(
      color: Color(0xFF116682),
    ),
    unselectedLabelStyle: TextStyle(
      color: Color(0xFF253140),
    ),
  ),
);
