import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/intro/presentation/widget/loading_bar.dart';
import 'package:meomulm_frontend/features/intro/presentation/widget/loading_text.dart';

/// 로딩 애니메이션 전체를 담당
class LoadingBarWidget extends StatefulWidget {
  const LoadingBarWidget({super.key});

  @override
  State<LoadingBarWidget> createState() => _LoadingBarWidgetState();
}

class _LoadingBarWidgetState extends State<LoadingBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 애니메이션 컨트롤러
  late Animation<double> _animation; // 진행률 애니메이션

  @override
  void initState() {
    super.initState();

    // 3초 동안 실행되는 로딩 애니메이션
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // 애니메이션 실행 (1회)
    _controller.forward();
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 프로그래스바 + 자동차
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: 50,
                    child: Stack(
                      children: [

                        /// 로딩 바
                        Positioned(
                          left: 0,
                          right: 5,
                          bottom: 10,
                          child: LoadingBar(progress: _animation.value),
                        ),

                        /// 자동차 아이콘
                        Positioned(
                          left: _animation.value * constraints!.maxWidth - 40,
                          bottom: 5,
                          child: Transform.flip(
                            flipX: true,
                            child: const Text(
                                '🚗', style: TextStyle(fontSize: 30)),
                          ),
                        ),

                        /// 집 아이콘 (끝점)
                        Positioned(
                          right: -4,
                          bottom: 5,
                          child: const Text('🏠', style: TextStyle(fontSize: 30)),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
        ),

        const SizedBox(height: 12),

        /// 로딩 텍스트
        const LoadingText(),
      ],
    );
  }
}
