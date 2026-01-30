import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/change_password/change_password_form_fields.dart';

class LoginChangePasswordScreen extends StatefulWidget {
  final int userId;

  const LoginChangePasswordScreen({super.key, required this.userId});

  @override
  State<LoginChangePasswordScreen> createState() =>
      _LoginChangePasswordScreenState();
}

class _LoginChangePasswordScreenState extends State<LoginChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();

  // FocusNode들을 생성
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _checkPasswordFocusNode = FocusNode();

  void _changePassword() async {
    final password = _passwordController.text.trim();
    final checkPassword = _checkPasswordController.text.trim();
    final passwordRegexp = RegexpUtils.validatePassword(password);
    final checkPasswordRegexp = RegexpUtils.validateCheckPassword(
      password,
      checkPassword,
    );

    if (passwordRegexp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordRegexp),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (checkPasswordRegexp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(checkPasswordRegexp),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      final res = await AuthService.LoginChangePassword(widget.userId, password);
      if(mounted){
        if(res != null || res != 0){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("비밀번호가 변경되었습니다."),
                  backgroundColor: AppColors.success)
          );
          context.push('${RoutePaths.login}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("비밀번호 변경에 실패했습니다."),
                backgroundColor: AppColors.error,
              )
          );
        }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context,).showSnackBar(
            SnackBar(content: Text('오류 : $e')));
      }
    }
  }

  void _moveLogin() {
    context.push('${RoutePaths.login}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.loginChangePassword, onBack: _moveLogin),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // 새 비밀번호 입력
            ChangePasswordFormFields(
              passwordController: _passwordController,
              checkPasswordController: _checkPasswordController,
              passwordFocusNode: _passwordFocusNode,
              checkPasswordFocusNode: _checkPasswordFocusNode,
            ),
            const SizedBox(height: 40),

            // 비밀번호 변경 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.gray6,
                  disabledBackgroundColor: AppColors.gray2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.gray4),
                  ),
                ),
                child: const Text(
                  ButtonLabels.apply,
                  style: AppTextStyles.inputTextMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
