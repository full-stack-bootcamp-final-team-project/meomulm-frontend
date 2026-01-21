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
  final String? label;
  final bool isRequired;
  final String? initialValue;
  final String? errorText;

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
    this.label,
    this.isRequired = false,
    this.initialValue,
    this.errorText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 2),
                const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),

        if (label != null) const SizedBox(height: 2),

        TextFormField(
          initialValue: initialValue,
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,


          obscureText: style == AppInputStyles.password ? obscureText : false,
          enabled: style == AppInputStyles.disabled ? false : enabled,

          decoration: decoration,
        ),
      ],
    );
  }
}
