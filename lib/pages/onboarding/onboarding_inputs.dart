import 'package:flutter/cupertino.dart' show CupertinoTextField, OverlayVisibilityMode;
import 'package:flutter/material.dart';

/// Onboarding text entry using [CupertinoTextField] inside [FormField], **not**
/// [TextFormField]. Material [InputDecorator] + [EditableText] still misbehaved
/// for some users (invisible Latin text, no caret) under RTL + scaled layout;
/// Cupertino uses a different implementation and paints reliably.
class OnboardingLabeledField extends StatefulWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
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
  State<OnboardingLabeledField> createState() => _OnboardingLabeledFieldState();
}

class _OnboardingLabeledFieldState extends State<OnboardingLabeledField> {
  FormFieldState<String>? _formFieldState;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncFormValue);
  }

  @override
  void didUpdateWidget(OnboardingLabeledField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncFormValue);
      widget.controller.addListener(_syncFormValue);
    }
  }

  void _syncFormValue() {
    _formFieldState?.didChange(widget.controller.text);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFormValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF1A2435) : const Color(0xFFE4E8EF);
    final borderColor = dark ? const Color(0xFFB0B8C8) : const Color(0xFF6B7280);
    final labelFg = dark ? Colors.white : Colors.black87;

    final typing = dark ? OnboardingLabeledField._typingOnDark : OnboardingLabeledField._typingOnLight;
    final hint = dark ? OnboardingLabeledField._hintOnDark : OnboardingLabeledField._hintOnLight;

    final textStyle = TextStyle(
      color: typing,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w500,
      fontFamily: widget.ltrInput ? null : OnboardingLabeledField._rabar,
      fontFamilyFallback:
          widget.ltrInput ? null : const ['Roboto', 'Noto Sans', 'sans-serif'],
    );

    final boxDecoration = BoxDecoration(
      color: fill,
      border: Border.all(color: borderColor, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: labelFg,
              height: 1.2,
            ),
          ),
        ),
        FormField<String>(
          initialValue: widget.controller.text,
          validator: widget.validator,
          builder: (state) {
            _formFieldState = state;
            final field = SizedBox(
              height: OnboardingLabeledField._rowHeight,
              child: CupertinoTextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                maxLines: 1,
                placeholder: widget.hintText,
                placeholderStyle: TextStyle(color: hint, fontSize: 15, height: 1.2),
                style: textStyle,
                cursorColor: typing,
                padding: const EdgeInsetsDirectional.only(start: 12, end: 10, top: 10, bottom: 10),
                decoration: boxDecoration,
                suffix: widget.suffixIcon,
                clearButtonMode: OverlayVisibilityMode.never,
                textAlign: widget.ltrInput ? TextAlign.left : TextAlign.start,
                keyboardType: TextInputType.text,
                autocorrect: false,
                spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
                onChanged: state.didChange,
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.ltrInput
                    ? Directionality(textDirection: TextDirection.ltr, child: field)
                    : field,
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
