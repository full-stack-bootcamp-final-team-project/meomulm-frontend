import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/auth/presentation/widgets/custom_text_field.dart';

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
            validator: _validateEmail,
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
          validator: _validatePassword,
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
          validator: (value) => _validateCheckPassword(value, passwordController.text),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 이름
        CustomTextField(
          label: "이름",
          isRequired: true,
          hintText: "이름을 입력하세요.",
          controller: nameController,
          focusNode: nameFocusNode,
          validator: _validateName,
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
            validator: _validatePhone,
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
          margin: const EdgeInsets.only(top: 28),
          height: 55,
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

  // 검증 함수들
  String? _validateEmail(String? value) {
    // 빈 값이면 아무것도 표시 안 함
    if (value == null || value.isEmpty) {
      return null;
    }
    // 입력을 시작했으면 검증
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return '유효하지 않은 이메일 형식입니다.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    // 빈 값이면 아무것도 표시 안 함
    if (value == null || value.isEmpty) {
      return null;
    }
    // 입력을 시작했으면 검증
    if (!RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$')
        .hasMatch(value)) {
      return '8~16자의 영문 대소문자, 숫자, 특수문자를 사용하세요.';
    }
    return null;
  }

  String? _validateCheckPassword(String? value, String password) {
    // 빈 값이면 아무것도 표시 안 함
    if (value == null || value.isEmpty) {
      return null;
    }
    // 입력을 시작했으면 검증
    if (password != value) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  String? _validateName(String? value) {
    // 빈 값이면 아무것도 표시 안 함
    if (value == null || value.isEmpty) {
      return null;
    }
    // 입력을 시작했으면 검증
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return '숫자는 입력할 수 없습니다.';
    }
    if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(value)) {
      return '이름은 영어와 한글만 가능합니다.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    // 빈 값이면 아무것도 표시 안 함
    if (value == null || value.isEmpty) {
      return null;
    }
    // 입력을 시작했으면 검증
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '숫자만 입력 가능합니다.';
    }
    if (value.length < 10) {
      return '전화번호는 최소 10자리 이상이어야 합니다.';
    }
    if (value.length > 11) {
      return '전화번호는 11자리 이하여야 합니다.';
    }
    return null;
  }
}