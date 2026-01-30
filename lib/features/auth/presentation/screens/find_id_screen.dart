import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_button_styles.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _checkUser() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final nameRegexp = RegexpUtils.validateName(name);
    final phoneRegexp = RegexpUtils.validatePhone(phone);

    if (nameRegexp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nameRegexp),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (phoneRegexp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(phoneRegexp),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final res = await AuthService.userEmailCheck(name, phone);

      if (mounted) {
        if (res != null) {
          // 둘 다 null이면 통과 → 모달창 표시
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              title: Text(
                '고객님의 이메일은',
                style: AppTextStyles.bodyLg,
                textAlign: TextAlign.center,
              ),
              content: Padding(padding: EdgeInsetsGeometry.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    res,
                    style: AppTextStyles.dialogLg,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '입니다.',
                    style: AppTextStyles.bodyLg,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed:  () => Navigator.pop(context),
                        child: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(AppButtonStyles.buttonWidthMd, AppButtonStyles.buttonHeightMd),
                        backgroundColor: AppColors.main,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)
                        )
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                '고객님의 이메일이 존재하지 않습니다.',
                style: AppTextStyles.bodyLg,
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:  () => Navigator.pop(context),
                      child: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(AppButtonStyles.buttonWidthMd, AppButtonStyles.buttonHeightMd),
                          backgroundColor: AppColors.main,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10)
                          ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
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
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          '아이디 찾기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // 이름 입력
              TextFieldWidget(
                label: "이름",
                hintText: "이름을 입력하세요",
                controller: _nameController,
              ),

              const SizedBox(height: 20),

              // 전화번호 입력
              TextFieldWidget(
                label: "전화번호",
                hintText: "전화번호를 입력하세요",
                controller: _phoneController,
              ),

              SizedBox(height: 40),

              // 아이디 찾기 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray6,
                    foregroundColor: AppColors.gray2,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.gray4),
                    ),
                  ),
                  onPressed: _checkUser,
                  child: const Text('아이디 찾기', style: AppTextStyles.inputTextMd),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}