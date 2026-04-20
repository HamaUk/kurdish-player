import 'package:flutter/material.dart';

const fontFamily = 'Rabar';

const _bottomSheetTheme = BottomSheetThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(3.0))),
);

const _dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
);

/// Adopting the 'perfect' pattern from optic_tv:
/// Apply Rabar font specifically to TextTheme only when Kurdish is selected.
/// This prevents icon font corruption and keeps English text default.
TextTheme buildTextTheme(Locale locale, TextTheme base) {
  if (locale.languageCode != 'ckb') return base;
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: fontFamily),
    displayMedium: base.displayMedium?.copyWith(fontFamily: fontFamily),
    displaySmall: base.displaySmall?.copyWith(fontFamily: fontFamily),
    headlineLarge: base.headlineLarge?.copyWith(fontFamily: fontFamily),
    headlineMedium: base.headlineMedium?.copyWith(fontFamily: fontFamily),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: fontFamily),
    titleLarge: base.titleLarge?.copyWith(fontFamily: fontFamily),
    titleMedium: base.titleMedium?.copyWith(fontFamily: fontFamily),
    titleSmall: base.titleSmall?.copyWith(fontFamily: fontFamily),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: fontFamily),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: fontFamily),
    bodySmall: base.bodySmall?.copyWith(fontFamily: fontFamily),
    labelLarge: base.labelLarge?.copyWith(fontFamily: fontFamily),
    labelMedium: base.labelMedium?.copyWith(fontFamily: fontFamily),
    labelSmall: base.labelSmall?.copyWith(fontFamily: fontFamily),
  );
}

ThemeData getLightTheme(Locale locale) {
  final base = ThemeData.light();
  return base.copyWith(
    textTheme: buildTextTheme(locale, base.textTheme),
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: _dialogTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE6272D),
      primary: const Color(0xFFE6272D),
      secondary: const Color(0xFFFEC213),
      tertiary: const Color(0xFF278E43),
    ),
    dividerTheme: const DividerThemeData(color: Colors.black12),
    dividerColor: Colors.black12,
    cardTheme: const CardThemeData(elevation: 1, shadowColor: Colors.black12),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 2,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE6272D).withOpacity(0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6272D))),
    ),
    drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
    scaffoldBackgroundColor: const Color(0xFFFBFBFB),
  );
}

ThemeData getDarkTheme(Locale locale) {
  final base = ThemeData.dark();
  return base.copyWith(
    textTheme: buildTextTheme(locale, base.textTheme),
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: _dialogTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE6272D),
      brightness: Brightness.dark,
      primary: const Color(0xFFE6272D),
      secondary: const Color(0xFFFEC213),
      onSecondary: Colors.black,
    ),
    dividerTheme: const DividerThemeData(color: Colors.white12),
    dividerColor: Colors.white12,
    cardTheme: const CardThemeData(elevation: 4, shadowColor: Colors.transparent),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFF121212),
      centerTitle: true,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 2,
      backgroundColor: Color(0xFF0F0F0F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6272D))),
    ),
    drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
  );
}

// Old constants for backward compatibility if needed, but preferably use getLightTheme(locale)
final lightTheme = getLightTheme(const Locale('en'));
final darkTheme = getDarkTheme(const Locale('en'));

final tvTheme = ThemeData(
  fontFamily: fontFamily,
  bottomSheetTheme: _bottomSheetTheme,
  dialogTheme: _dialogTheme,
  drawerTheme: const DrawerThemeData(shape: RoundedRectangleBorder(), endShape: RoundedRectangleBorder()),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE6272D)),
  dividerTheme: const DividerThemeData(color: Colors.black12),
  dividerColor: Colors.black12,
  scrollbarTheme: const ScrollbarThemeData(radius: Radius.circular(10)),
);

final tvDarkTheme = ThemeData(
  fontFamily: fontFamily,
  bottomSheetTheme: _bottomSheetTheme,
  dialogTheme: _dialogTheme,
  drawerTheme: const DrawerThemeData(shape: RoundedRectangleBorder(), endShape: RoundedRectangleBorder()),
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE6272D),
    brightness: Brightness.dark,
  ),
  dividerTheme: const DividerThemeData(color: Colors.white12),
  dividerColor: Colors.white12,
  scrollbarTheme: const ScrollbarThemeData(radius: Radius.circular(10)),
);
