import 'package:flutter/material.dart';

/// Labels plus a **fixed-height** input shell. On some RTL / scaled layouts,
/// [TextFormField] with outline [InputDecoration] can lay out at **zero height**
/// while the caption still paints; this avoids that by drawing the box with
/// [DecoratedBox] and using a collapsed inner decoration.
class OnboardingLabeledField extends StatelessWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  static const double _rowHeight = 52;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        child: TextFormField(
                          controller: controller,
                          obscureText: obscureText,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: fg, fontSize: 16, height: 1.2),
                          cursorColor: fg,
                          decoration: InputDecoration.collapsed(
                            hintText: hintText,
                            hintStyle: TextStyle(color: hint, fontSize: 15, height: 1.2),
                          ),
                          validator: validator,
                        ),
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
