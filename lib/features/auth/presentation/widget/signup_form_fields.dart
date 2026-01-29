import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/custom_text_field.dart';

class SignupFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController checkPasswordController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode checkPasswordFocusNode;
  final FocusNode nameFocusNode;
  final FocusNode phoneFocusNode;
  final VoidCallback onCheckEmail;
  final VoidCallback onCheckPhone;

  const SignupFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.checkPasswordController,
    required this.nameController,
    required this.phoneController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.checkPasswordFocusNode,
    required this.nameFocusNode,
    required this.phoneFocusNode,
    required this.onCheckEmail,
    required this.onCheckPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이메일 입력 (중복확인 버튼 포함)
        _buildFieldWithButton(
          field: CustomTextField(
            label: "이메일",
            isRequired: true,
            hintText: "abc@exam.com",
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            validator: (email) => RegexpUtils.validateEmail(email),
          ),
          onPressed: onCheckEmail,
        ),
        const SizedBox(height: AppSpacing.xl),

        // 비밀번호
        CustomTextField(
          label: "비밀번호",
          isRequired: true,
          hintText: "비밀번호를 입력하세요",
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: true,
          validator: (password) => RegexpUtils.validatePassword(password),
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
          validator: (password) => RegexpUtils.validateCheckPassword(password, passwordController.text),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 이름
        CustomTextField(
          label: "이름",
          isRequired: true,
          hintText: "이름을 입력하세요.",
          controller: nameController,
          focusNode: nameFocusNode,
          validator: (name) => RegexpUtils.validateName(name),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 연락처 (중복확인 버튼 포함)
        _buildFieldWithButton(
          field: CustomTextField(
            label: "연락처",
            isRequired: true,
            hintText: "연락처를 입력하세요.(- 제외)",
            controller: phoneController,
            focusNode: phoneFocusNode,
            keyboardType: TextInputType.phone,
            validator: (phone) => RegexpUtils.validatePhone(phone),
          ),
          onPressed: onCheckPhone,
        ),
      ],
    );
  }

  // 중복확인 버튼이 있는 필드 위젯
  Widget _buildFieldWithButton({
    required Widget field,
    required VoidCallback onPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: field),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 22),
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              backgroundColor: AppColors.main,
              foregroundColor: AppColors.white,
            ),
            child: const Text("중복확인"),
          ),
        ),
      ],
    );
  }
}