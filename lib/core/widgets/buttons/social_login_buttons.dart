import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';


/// =====================
/// 소셜 로그인 버튼
/// =====================
// 카카오 로그인
class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const KakaoLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyles.kakaoLoginButtonStyle().copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/kakao_logo.png',
            // 필요 시 width, height 속성 지정
          ),
          SizedBox(width: AppSpacing.sm),
          Text("카카오 로그인")
        ],
      ),
    );
  }
}

// 네이버 로그인
class NaverLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NaverLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyles.naverLoginButtonStyle().copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/naver_logo.png',
            // 필요 시 width, height 속성 지정
          ),
          SizedBox(width: AppSpacing.sm),
          Text("네이버 로그인")
        ],
      ),
    );
  }

}