import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

class LoginButtonFields extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onKakaoLogin;
  final VoidCallback onNaverLogin;

  const LoginButtonFields({
    super.key,
    required this.isLoading,
    required this.onLogin,
    required this.onKakaoLogin,
    required this.onNaverLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 로그인 버튼
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.gray4,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.mediumRadius,
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text('${ButtonLabels.login}', style: AppTextStyles.buttonLg),
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // 카카오로그인 버튼
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onKakaoLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kakaoBg,
              foregroundColor: AppColors.black,
              disabledBackgroundColor: AppColors.gray4,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.mediumRadius,
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/kakao_logo.png', height: 20),
                      const SizedBox(width: 20),
                      Text('카카오로그인', style: AppTextStyles.kakaoLg),
                    ],
                  ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // 네이버로그인 버튼
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onNaverLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.naverBg,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.gray4,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.mediumRadius,
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/naver_logo.png', height: 20),
                      const SizedBox(width: 20),
                      Text('네이버로그인', style: AppTextStyles.naverLg),
                    ],
                  ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // 아이디 찾기 / 비밀번호 찾기 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => context.push('${RoutePaths.findId}'),
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
              child: Text(
                "${ButtonLabels.findId}",
                style: TextStyle(color: AppColors.main, fontSize: 14),
              ),
            ),
            SizedBox(width: 1),
            Text("|", style: TextStyle(color: AppColors.main, fontSize: 14)),
            SizedBox(width: 1),
            TextButton(
              onPressed: () => context.push('${RoutePaths.confirmPassword}'),
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
              child: Text(
                "${ButtonLabels.changePassword}",
                style: TextStyle(color: AppColors.main, fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 50),

        // 회원가입 링크
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('계정이 없으신가요?', style: TextStyle(color: AppColors.main)),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => context.push('${RoutePaths.signup}'),
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
              child: Text('회원가입하기', style: AppTextStyles.bodyMd),
            ),
          ],
        ),
      ],
    );
  }
}
