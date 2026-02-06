import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/phone_number_formatter.dart';

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
  final VoidCallback? onCheckEmail;
  final VoidCallback onCheckPhone;
  final bool isEmailChecked;
  final bool isPasswordChecked;
  final bool isCheckPasswordChecked;
  final bool isPhoneChecked;
  final bool isNameChecked;
  final bool isKakaoSignup;

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
    this.onCheckEmail,
    required this.onCheckPhone,
    required this.isEmailChecked,
    required this.isPasswordChecked,
    required this.isCheckPasswordChecked,
    required this.isPhoneChecked,
    required this.isNameChecked,
    required this.isKakaoSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이메일 입력 (중복확인 버튼 포함)
        buildFieldWithButton(
          field: CustomTextField(
            label: "이메일",
            isRequired: true,
            hintText: "abc@exam.com",
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            validator: (email) => RegexpUtils.validateEmail(email),
            helperText: isEmailChecked ? InputMessages.validEmail : null,
            helperStyle: TextStyle(color: AppColors.success),
            readOnly: isKakaoSignup,
            onFieldSubmitted: (_) => onCheckEmail?.call(),
          ),
          onPressed: isKakaoSignup ? null : onCheckEmail,
          label: "중복확인",
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
          onFieldSubmitted: (_) {
            if (nameController.text.isEmpty) {
              FocusScope.of(context).requestFocus(nameFocusNode);
            } else {
              FocusScope.of(context).requestFocus(phoneFocusNode);
            }
          },
          textInputAction: TextInputAction.next,
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
          helperText: isNameChecked ? InputMessages.validName : null,
          helperStyle: TextStyle(color: AppColors.success),
          readOnly: isKakaoSignup,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(phoneFocusNode);
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.xl),

        // 연락처 (중복확인 버튼 포함)
        buildFieldWithButton(
          field: CustomTextField(
            label: "연락처",
            isRequired: true,
            hintText: "연락처를 입력하세요.",
            controller: phoneController,
            focusNode: phoneFocusNode,
            keyboardType: TextInputType.phone,
            validator: (phone) => RegexpUtils.validatePhone(phone),
            helperText: isPhoneChecked ? InputMessages.validPhone : null,
            helperStyle: TextStyle(color: AppColors.success),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              PhoneNumberFormatter(),
            ],
            onFieldSubmitted: (_) => onCheckPhone.call(),
          ),
          onPressed: onCheckPhone,
          label: "중복확인",
        ),
      ],
    );
  }
}
