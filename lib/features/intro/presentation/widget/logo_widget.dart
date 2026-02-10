import 'package:flutter/material.dart';

/// 앱 메인 로고 표시
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 로컬 에셋 이미지 로드
          Image.asset(
            'assets/images/main_logo.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}