import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/birth_date_selector.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  void _confirmPassword() async {
    final email = _emailController.text.trim();
    final birth = _birthController.text.trim();
    final emailRegexp = RegexpUtils.validateEmail(email);

    if(emailRegexp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailRegexp),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if(birth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(InputMessages.emptyBirth),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final userId = await AuthService.confirmPassword(email, birth);

      if(mounted){
        if(userId != null){
          print(userId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("본인인증에 성공했습니다. 비밀번호 변경 페이지로 이동합니다."),
            backgroundColor: AppColors.success)
          );
          context.go('${RoutePaths.loginChangePassword}/${userId}', extra: userId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("본인인증에 실패했습니다. 다시 입력해주세요."),
                backgroundColor: AppColors.error,
              )
          );
        }
      }

    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류 : $e')));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          TitleLabels.verifyIdentity,
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // 이메일 입력
            TextFieldWidget(
              label: "이메일",
              hintText: "이메일을 입력하세요.",
              controller: _emailController,
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
                  disabledBackgroundColor: const Color(0xFFF3F6FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFCACACA)),
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