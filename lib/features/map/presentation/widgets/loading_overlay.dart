import 'package:flutter/material.dart';

/// 전체 화면 위에 로딩 인디케이터를 표시하는 오버레이 위젯
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
