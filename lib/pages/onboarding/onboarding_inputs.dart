import 'package:flutter/material.dart';

/// Onboarding frosted cards and floating [InputDecorator] labels can fail to
/// paint clearly on some devices. This widget always draws a visible caption
/// plus a filled outline field (no floating label merge issues).
class OnboardingLabeledField extends StatelessWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF1A2435) : const Color(0xFFE4E8EF);
    final borderColor = dark ? const Color(0xFFB0B8C8) : const Color(0xFF6B7280);
    final fg = dark ? Colors.white : Colors.black87;
    final hint = dark ? const Color(0xFF9CA8BC) : const Color(0xFF6B7280);

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
              color: fg,
              height: 1.2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          minLines: 1,
          style: TextStyle(color: fg, fontSize: 16, height: 1.35),
          cursorColor: fg,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hint, fontSize: 15),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: fill,
            isDense: true,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.error, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
