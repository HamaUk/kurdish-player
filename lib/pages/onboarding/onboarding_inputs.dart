import 'package:flutter/material.dart';

/// Onboarding inputs: fixed layout shell + strong colors / selection theme.
///
/// Kurdish (`ckb`) no longer applies Rabar to [TextTheme.body*] globally
/// (see `buildTextTheme` in `theme.dart`): [TextFormField] was merging Rabar into
/// [EditableText], which often paints **no Latin/ASCII** while labels still
/// looked fine. Title fields still opt into Rabar explicitly when needed.
class OnboardingLabeledField extends StatelessWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    /// Latin / numbers (URLs, hosts, credentials).
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

  static const Color _typingOnDark = Color(0xFFF2F5FF);
  static const Color _typingOnLight = Color(0xFF0D1117);
  static const Color _hintOnDark = Color(0xFF9FB0D0);
  static const Color _hintOnLight = Color(0xFF5C6570);

  static const String _rabar = 'Rabar';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF1A2435) : const Color(0xFFE4E8EF);
    final borderColor = dark ? const Color(0xFFB0B8C8) : const Color(0xFF6B7280);
    final labelFg = dark ? Colors.white : Colors.black87;

    final typing = dark ? _typingOnDark : _typingOnLight;
    final hint = dark ? _hintOnDark : _hintOnLight;

    final cs = theme.colorScheme;
    final isolatedTheme = theme.copyWith(
      colorScheme: cs.copyWith(
        onSurface: typing,
        onSurfaceVariant: hint,
        surface: fill,
        surfaceTint: Colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: typing,
        selectionColor: typing.withOpacity(0.35),
        selectionHandleColor: typing,
      ),
    );

    final fieldStyle = TextStyle(
      color: typing,
      fontSize: 16,
      height: 1.25,
      fontWeight: FontWeight.w500,
      fontFamily: ltrInput ? null : _rabar,
      fontFamilyFallback: ltrInput ? null : const ['Roboto', 'Noto Sans', 'sans-serif'],
    );

    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      keyboardType: TextInputType.text,
      textAlignVertical: TextAlignVertical.center,
      textAlign: ltrInput ? TextAlign.left : TextAlign.start,
      style: fieldStyle,
      cursorColor: typing,
      cursorWidth: 2,
      decoration: InputDecoration.collapsed(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hint,
          fontSize: 15,
          height: 1.25,
          fontFamily: ltrInput ? null : _rabar,
          fontFamilyFallback: ltrInput ? null : const ['Roboto', 'Noto Sans', 'sans-serif'],
        ),
      ),
      validator: validator,
    );

    final wrappedField = Theme(
      data: isolatedTheme,
      child: ltrInput
          ? Directionality(textDirection: TextDirection.ltr, child: field)
          : field,
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
