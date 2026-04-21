import 'package:flutter/material.dart';

/// Labels plus a **fixed-height** input shell. On some RTL / scaled layouts,
/// [TextFormField] with outline [InputDecoration] can lay out at **zero height**
/// while the caption still paints; this avoids that by drawing the box with
/// [DecoratedBox] and using a collapsed inner decoration.
///
/// Typed text and cursor use **hard-coded contrast** and an isolated [Theme] so
/// global [ColorScheme.onSurface] / selection colors cannot match the field fill
/// (which made caret + glyphs effectively invisible).
class OnboardingLabeledField extends StatelessWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    /// Use for URLs, hosts, usernames, passwords so Latin/numbers type LTR
    /// inside an RTL app and paint with consistent colors.
    this.ltrInput = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool ltrInput;

  static const double _rowHeight = 52;

  /// Typed text / caret — not derived from [ThemeData.colorScheme] to avoid
  /// matching the dark fill when the app theme is inconsistent with the card.
  static const Color _typingOnDark = Color(0xFFF2F5FF);
  static const Color _typingOnLight = Color(0xFF0D1117);
  static const Color _hintOnDark = Color(0xFF9FB0D0);
  static const Color _hintOnLight = Color(0xFF5C6570);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF1A2435) : const Color(0xFFE4E8EF);
    final borderColor = dark ? const Color(0xFFB0B8C8) : const Color(0xFF6B7280);
    final labelFg = dark ? Colors.white : Colors.black87;

    final typing = dark ? _typingOnDark : _typingOnLight;
    final hint = dark ? _hintOnDark : _hintOnLight;

    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      keyboardType: TextInputType.text,
      textAlignVertical: TextAlignVertical.center,
      textAlign: ltrInput ? TextAlign.left : TextAlign.start,
      style: TextStyle(
        color: typing,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: typing,
      cursorWidth: 2,
      decoration: InputDecoration.collapsed(
        hintText: hintText,
        hintStyle: TextStyle(color: hint, fontSize: 15, fontWeight: FontWeight.w400),
      ),
      validator: validator,
    );

    final wrappedField = Theme(
      data: theme.copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: typing,
          selectionColor: typing.withOpacity(0.35),
          selectionHandleColor: typing,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: typing, fontSize: 16),
        child: ltrInput
            ? Directionality(textDirection: TextDirection.ltr, child: field)
            : field,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: labelFg,
              height: 1.2,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fill,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: SizedBox(
              height: _rowHeight,
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
                        child: wrappedField,
                      ),
                    ),
                    if (suffixIcon != null)
                      Center(
                        heightFactor: 1,
                        child: suffixIcon,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
