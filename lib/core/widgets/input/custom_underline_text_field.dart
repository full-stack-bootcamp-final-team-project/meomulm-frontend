import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/form_label.dart';

class CustomUnderlineTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomUnderlineTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: label, isRequired: isRequired),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          // 실시간 검증을 위해 autovalidateMode 설정
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: AppInputDecorations.underline(),
          validator: validator,
        ),
      ],
    );
  }
}