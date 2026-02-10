import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 5초 뒤 메인으로 이동
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        context.go(AppRouter.RoutePaths.home);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🔥 뒤로가기 완전 차단
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),

              // 중앙 원 + 체크 아이콘
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: AppSpacing.md,
                          color: AppColors.onPressed,
                        ),
                      ),
                    ),
                    const Icon(
                      AppIcons.check,
                      size: 80,
                      color: AppColors.onPressed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              const Text(
                '결제가 완료되었습니다!',
                textAlign: TextAlign.center,
                style: AppTextStyles.appBarTitle,
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // 예약 확인 버튼
              SizedBox(
                width: 120,
                height: AppSpacing.xxxl,
                child: OutlinedButton(
                  onPressed: () {
                    context.go(
                      '${RoutePaths.myPage}${RoutePaths.myReservation}?tab=0',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: AppColors.onPressed,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    '예약 확인',
                    style: TextStyle(
                      color: AppColors.onPressed,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              const Divider(thickness: 1, color: Color(0xFFC1C1C1)),

              // 메인으로 돌아가기 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: GestureDetector(
                  onTap: () {
                    context.go(RoutePaths.home);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.onPressed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '메인으로 돌아가기',
                      style: AppTextStyles.buttonLg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
