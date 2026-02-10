import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
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
  final TextEditingController _checkPasswordController = TextEditingController();

  // FocusNode
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _checkPasswordFocusNode = FocusNode();

  // 입력값 검증
  bool _isPasswordChecked = false;
  bool _isCheckPasswordChecked = false;

  // 앱 시작하고 입력값 검증
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _passwordFocusNode.requestFocus();
    });

    _passwordController.addListener(() {
      final password = _passwordController.text.trim();
      setState(() {
        _isPasswordChecked = RegexpUtils.validatePassword(password) == null;
      });
    });

    _checkPasswordController.addListener(() {
      final password = _passwordController.text.trim();
      final checkPassword = _checkPasswordController.text.trim();
      setState(() {
        _isCheckPasswordChecked = RegexpUtils.validateCheckPassword(password, checkPassword) == null;
      });
    });
  }

  // 비밀번호 변경 (로그인)
  void _changePassword() async {
    // 입력값 검증
    final password = _passwordController.text.trim();
    final checkPassword = _checkPasswordController.text.trim();
    final passwordRegexp = RegexpUtils.validatePassword(password);
    final checkPasswordRegexp = RegexpUtils.validateCheckPassword(password, checkPassword);

    if (passwordRegexp != null) {
      SnackMessenger.showMessage(
          context,
          passwordRegexp,
          type: ToastType.error
      );
      return;
    }

    if (checkPasswordRegexp != null) {
      SnackMessenger.showMessage(
          context,
          checkPasswordRegexp,
          type: ToastType.error
      );
      return;
    }

    try {
      final res = await AuthService.LoginChangePassword(widget.userId, password);

      if(!mounted) return;

      if(res != null || res != 0){
        SnackMessenger.showMessage(
            context,
            "비밀번호가 변경되었습니다.",
            type: ToastType.success
        );
        context.push('${RoutePaths.login}');

      } else {
        SnackMessenger.showMessage(
            context,
            "비밀번호 변경에 실패했습니다.",
            type: ToastType.error
        );
      }

    } catch (e) {
      if(!mounted) return;
      SnackMessenger.showMessage(
          context,
          '오류 : $e',
          type: ToastType.error
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.loginChangePassword),
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
              isPasswordChecked: _isPasswordChecked,
              isCheckPasswordChecked: _isCheckPasswordChecked,
              onSubmit: _changePassword,
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
