import 'package:flutter/material.dart';

const fontFamily = 'Rabar';
const _bottomSheetTheme = BottomSheetThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(3.0))),
);
const _dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
);
final lightTheme = ThemeData(
  fontFamily: fontFamily,
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
  drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
  scaffoldBackgroundColor: const Color(0xFFFBFBFB),
);

final darkTheme = ThemeData(
  fontFamily: fontFamily,
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
  drawerTheme: const DrawerThemeData(endShape: ContinuousRectangleBorder()),
  scaffoldBackgroundColor: const Color(0xFF0A0A0A),
);

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
