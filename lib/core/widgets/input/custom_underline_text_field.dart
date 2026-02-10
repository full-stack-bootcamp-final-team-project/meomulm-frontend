import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/form_label.dart';

class CustomUnderlineTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const CustomUnderlineTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
  });


  @override
  State<CustomUnderlineTextField> createState() => _CustomUnderlineTextFieldState();
}

class _CustomUnderlineTextFieldState extends State<CustomUnderlineTextField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: widget.label, isRequired: widget.isRequired),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          // 실시간 검증을 위해 autovalidateMode 설정
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: AppInputDecorations.underline(),
          validator: widget.validator,
        ),
      ],
    );
  }

}