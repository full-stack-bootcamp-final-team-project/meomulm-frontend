import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/form_label.dart';

class TextFieldWidget extends StatefulWidget {
  final String? label;
  final bool isRequired;
  final String? hintText;
  final String? errorText;

  final TextEditingController? controller;
  final String? initialValue;

  final AppInputStyles style;
  final TextInputType keyboardType;
  final int maxLines;

  final bool enabled;

  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const TextFieldWidget({
    super.key,
    this.label,
    this.isRequired = false,
    this.hintText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.style = AppInputStyles.standard,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.style == AppInputStyles.password;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  InputDecoration _getDecoration() {
    switch (widget.style) {
      case AppInputStyles.standard:
        return AppInputDecorations.standard(
          hintText: widget.hintText,
          errorText: widget.errorText,
        );
      case AppInputStyles.underline:
        return AppInputDecorations.underline(
          hintText: widget.hintText,
          errorText: widget.errorText,
        );
      case AppInputStyles.disabled:
        return AppInputDecorations.disabled();
      case AppInputStyles.password:
        return AppInputDecorations.password(
          hintText: widget.hintText,
          obscureText: _obscureText,
          onToggleVisibility: _toggleVisibility,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          FormLabel(
            label: widget.label!,
            isRequired: widget.isRequired,
          ),

        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          obscureText: widget.style == AppInputStyles.password ? _obscureText : false,
          enabled: widget.style == AppInputStyles.disabled ? false : widget.enabled,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: _getDecoration(),
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
        ),
      ],
    );
  }
}