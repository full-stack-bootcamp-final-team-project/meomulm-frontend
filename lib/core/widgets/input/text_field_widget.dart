import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';


class TextFieldWidget extends StatelessWidget {
  final AppInputStyles style;
  final InputDecoration decoration;

  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const TextFieldWidget({
    super.key,
    required this.decoration,
    this.style = AppInputStyles.standard,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,

      obscureText: style == AppInputStyles.password ? obscureText : false,
      enabled: style == AppInputStyles.disabled ? false : enabled,

      decoration: decoration,
    );
  }
}
