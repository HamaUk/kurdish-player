import 'package:flutter/material.dart';

const fontFamily = 'Rabar';

const _bottomSheetTheme = BottomSheetThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
  backgroundColor: Colors.transparent,
  elevation: 0,
);

const _dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
);

/// Adopting the 'perfect' pattern from optic_tv:
/// Apply Rabar font specifically to TextTheme only when Kurdish is selected.
///
/// **Do not** set Rabar on [TextTheme.bodyLarge] / [bodyMedium] / [bodySmall]:
/// [TextField] and [TextFormField] merge those styles for editable text; Rabar
/// can fail to render Latin/ASCII in the engine while static [Text] labels
/// still look fine (invisible “empty” inputs). Headlines, titles, and labels
/// keep Rabar for Kurdish UI chrome.
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
    labelLarge: base.labelLarge?.copyWith(fontFamily: fontFamily),
    labelMedium: base.labelMedium?.copyWith(fontFamily: fontFamily),
    labelSmall: base.labelSmall?.copyWith(fontFamily: fontFamily),
  );
}

ThemeData getLightTheme(Locale locale) {
  final base = ThemeData.light();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFE6272D),
    primary: const Color(0xFFE6272D),
    secondary: const Color(0xFFFEC213),
    tertiary: const Color(0xFF278E43),
  );

  return base.copyWith(
    textTheme: buildTextTheme(locale, base.textTheme),
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: _dialogTheme,
    colorScheme: colorScheme,
    dividerTheme: const DividerThemeData(color: Colors.black12, thickness: 1),
    dividerColor: Colors.black12,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.black.withOpacity(0.05))),
      clipBehavior: Clip.antiAlias,
    ),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      indicatorColor: colorScheme.primary.withOpacity(0.12),
      labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.04),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black26)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black26)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colorScheme.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colorScheme.error, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      prefixIconColor: Colors.black54,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  );
}

ThemeData getDarkTheme(Locale locale) {
  final base = ThemeData.dark();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFE6272D),
    brightness: Brightness.dark,
    primary: const Color(0xFFE6272D),
    secondary: const Color(0xFFFEC213),
    surface: const Color(0xFF1A1C1E),
  );

  return base.copyWith(
    textTheme: buildTextTheme(locale, base.textTheme),
    bottomSheetTheme: _bottomSheetTheme.copyWith(backgroundColor: Colors.transparent),
    dialogTheme: _dialogTheme,
    colorScheme: colorScheme,
    dividerTheme: const DividerThemeData(color: Colors.white12, thickness: 1),
    dividerColor: Colors.white12,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white.withOpacity(0.08))),
      color: const Color(0xFF24272B),
      clipBehavior: Clip.antiAlias,
    ),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFF0F1113),
      centerTitle: true,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: const Color(0xFF0F1113),
      indicatorColor: colorScheme.primary.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2F38),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white38)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white38)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colorScheme.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colorScheme.error, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      prefixIconColor: Colors.white70,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
    scaffoldBackgroundColor: const Color(0xFF0F1113),
  );
}

// Old constants for backward compatibility
final lightTheme = getLightTheme(const Locale('en'));
final darkTheme = getDarkTheme(const Locale('en'));

ThemeData getTvTheme(Locale locale) {
  final base = getLightTheme(locale);
  return base.copyWith(
    drawerTheme: const DrawerThemeData(shape: RoundedRectangleBorder(), endShape: RoundedRectangleBorder()),
  );
}

ThemeData getTvDarkTheme(Locale locale) {
  final base = getDarkTheme(locale);
  return base.copyWith(
    drawerTheme: const DrawerThemeData(shape: RoundedRectangleBorder(), endShape: RoundedRectangleBorder()),
    scaffoldBackgroundColor: Colors.black,
  );
}

final tvTheme = getTvTheme(const Locale('en'));
final tvDarkTheme = getTvDarkTheme(const Locale('en'));
