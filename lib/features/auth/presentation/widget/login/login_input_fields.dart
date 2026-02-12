import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';

class LoginInputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const LoginInputFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/login_logo.png', height: 80),
        SizedBox(height: 50),

        // 로그인 바
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
              child: Text(
                "${ButtonLabels.login}",
                style: TextStyle(color: AppColors.gray2, fontSize: 18),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: AppSpacing.xxl),

        CustomTextField(
          hintText: "이메일를 입력하세요",
          controller: emailController,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
          textInputAction: TextInputAction.next,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: AppSpacing.lg),

        CustomTextField(
          hintText: "비밀번호를 입력하세요",
          controller: passwordController,
          onFieldSubmitted: (_) => onSubmit(),
          focusNode: passwordFocusNode,
          obscureText: true,
        ),
        SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
