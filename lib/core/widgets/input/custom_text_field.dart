import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/form_label.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? helperText;
  final TextStyle? helperStyle;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters; // 연락처 자동 변경 처리
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.helperText,
    this.helperStyle,
    this.readOnly = false,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.obscureText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: widget.label, isRequired: widget.isRequired),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          obscureText: isPasswordField ? _obscureText : false,
          readOnly: widget.readOnly,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          // 실시간 검증을 위해 autovalidateMode 설정
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            helperText: widget.helperText,
            helperStyle: widget.helperStyle,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputPlaceholder,
            filled: true,
            fillColor: widget.readOnly
                ? AppColors.gray6
                : AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: AppColors.gray3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: AppColors.gray3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: AppColors.main, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),

            // 👁 눈 아이콘
            suffixIcon: isPasswordField
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.gray3
              ),
              onPressed: widget.readOnly
                  ? null
                  : () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
