import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/ui/messages_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';

class ChangePasswordFormFields extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController checkPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode checkPasswordFocusNode;
  final bool isPasswordChecked;
  final bool isCheckPasswordChecked;
  final VoidCallback onSubmit;

  const ChangePasswordFormFields({
    super.key,
    required this.passwordController,
    required this.checkPasswordController,
    required this.passwordFocusNode,
    required this.checkPasswordFocusNode,
    required this.isPasswordChecked,
    required this.isCheckPasswordChecked,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 비밀번호
        CustomTextField(
          label: "비밀번호",
          isRequired: true,
          hintText: "비밀번호를 입력하세요",
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: true,
          validator: (password) => RegexpUtils.validatePassword(password),
          helperText: isPasswordChecked ? InputMessages.validPassword : null,
          helperStyle: TextStyle(color: AppColors.success),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(checkPasswordFocusNode);
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.xl),

        // 비밀번호 확인
        CustomTextField(
          label: "비밀번호 확인",
          isRequired: true,
          hintText: "비밀번호를 다시 입력하세요",
          controller: checkPasswordController,
          focusNode: checkPasswordFocusNode,
          obscureText: true,
          validator: (password) => RegexpUtils.validateCheckPassword(
            password,
            passwordController.text,
          ),
          helperText: isCheckPasswordChecked
              ? InputMessages.matchPassword
              : null,
          helperStyle: TextStyle(color: AppColors.success),
          onFieldSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
