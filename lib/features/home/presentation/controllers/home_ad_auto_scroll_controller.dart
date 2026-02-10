import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class HomeAdAutoScrollController {
  final ScrollController scrollController;

  // 자동 스크롤 타이머
  Timer? _timer;
  // 중복 실행 방지
  bool _isAnimating = false;

  HomeAdAutoScrollController(this.scrollController);

  // 자동 스크롤 시작
  void start(BuildContext context) {
    _timer?.cancel(); // 타이머 제거

    // 5초마다 카드 하나씩 이동 (무한 루프)
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!scrollController.hasClients) return;
      if (_isAnimating) return;

      _isAnimating = true;

      // 광고 카드 간격
      const itemSpacing = AppSpacing.lg;
      // 화면 기준 카드 가로 크기 계산
      final width = MediaQuery.of(context).size.width;
      final itemWidth =
          (width - AppSpacing.lg * 2 - itemSpacing) / 2;

      // 이동 값
      final step = itemWidth + itemSpacing;
      // 스크롤 이동 최대 값
      final maxOffset = scrollController.position.maxScrollExtent;

      // 현재 인덱스
      final currentIndex = (scrollController.offset / step).round();
      final nextOffset = (currentIndex + 1) * step;

      // 마지막 카드가 아니면 이동
      if (nextOffset <= maxOffset) {
        await scrollController.animateTo(
          nextOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // 마지막이면 처음으로 이동
        // 처음으로 이동하는 동안 마지막 카드 잠깐 중지(무한 루프용)
        await Future.delayed(const Duration(milliseconds: 700));

        // 애니메이션
        await scrollController.animateTo(
          maxOffset - 8,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );

        // 처음으로 이동
        scrollController.jumpTo(0);
      }

      _isAnimating = false;
    });
  }

  // 자동 스크롤 중지
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }
}
