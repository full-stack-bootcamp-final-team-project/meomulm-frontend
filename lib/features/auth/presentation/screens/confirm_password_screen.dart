import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/signup/birth_date_selector.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  // FocusNode
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _emailFocusNode.requestFocus();
    });
  }

  // 본인 인증
  void _confirmPassword() async {
    // 입력값 검증
    final email = _emailController.text.trim();
    final birth = _birthController.text.trim();
    final emailRegexp = RegexpUtils.validateEmail(email);

    if(emailRegexp != null) {
      SnackMessenger.showMessage(
          context,
          emailRegexp,
          type: ToastType.error
      );
      return;
    }

    if(birth.isEmpty) {
      SnackMessenger.showMessage(
          context,
          InputMessages.emptyBirth,
          type: ToastType.error
      );
      return;
    }

    try {
      final userId = await AuthService.confirmPassword(email, birth);

      if(!mounted) return;
        if(userId != null){
          print(userId);
          SnackMessenger.showMessage(
              context,
              "본인인증에 성공했습니다. 비밀번호 변경 페이지로 이동합니다.",
              type: ToastType.success
          );
          context.push('${RoutePaths.loginChangePassword}/${userId}', extra: userId);

        } else {
          SnackMessenger.showMessage(
              context,
              "본인인증에 실패했습니다. 다시 입력해주세요.",
              type: ToastType.error
          );
        }

    } catch(e) {
      if (!mounted) return;
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
      appBar: AppBarWidget(title: TitleLabels.verifyIdentity),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // 이메일 입력
            CustomTextField(
              label: "이메일",
              isRequired: true,
              hintText: "abc@exam.com",
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: (email) => RegexpUtils.validateEmail(email),
            ),
            const SizedBox(height: 24),

            // 생년월일 입력
            BirthDateSelector(
              birthController: _birthController,
            ),

            const SizedBox(height: 40),

            // 비밀번호 변경 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _confirmPassword,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.gray6,
                  foregroundColor: AppColors.gray2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.gray4),
                  ),
                ),
                child: const Text(
                  ButtonLabels.changePassword,
                  style:  AppTextStyles.inputTextMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}