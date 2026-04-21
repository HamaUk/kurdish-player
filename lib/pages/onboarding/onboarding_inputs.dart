import 'package:flutter/material.dart';

/// Onboarding cards use a very light frosted tint; default [InputDecorationTheme]
/// fills can match the card and look like empty space. These decorations keep
/// fields, labels, hints, and icons clearly visible in both themes.
InputDecoration onboardingInputDecoration(
  ThemeData theme, {
  required String labelText,
  String? hintText,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  final cs = theme.colorScheme;
  final dark = theme.brightness == Brightness.dark;
  final fill = dark ? const Color(0xFF252E42) : const Color(0xFFF2F4F8);
  final labelMuted = dark ? Colors.white70 : Colors.black54;
  final border = dark ? Colors.white38 : Colors.black26;
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    filled: true,
    fillColor: fill,
    isDense: true,
    labelStyle: TextStyle(color: labelMuted, fontWeight: FontWeight.w500),
    floatingLabelStyle: TextStyle(
      color: dark ? Colors.white : Colors.black87,
      fontWeight: FontWeight.w600,
    ),
    hintStyle: TextStyle(color: dark ? Colors.white54 : Colors.black45),
    prefixIconColor: labelMuted,
    prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: cs.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: cs.error, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );
}

TextStyle onboardingInputTextStyle(ThemeData theme) {
  final dark = theme.brightness == Brightness.dark;
  return TextStyle(color: dark ? Colors.white : Colors.black87, fontSize: 16, height: 1.35);
}
