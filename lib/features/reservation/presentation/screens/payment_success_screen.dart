import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';

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
    _deleteBookerInfo();

    // 5초 뒤 메인으로 이동
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        context.go(AppRouter.RoutePaths.home);
      }
    });
  }

  Future<void> _deleteBookerInfo() async {
    final reservationProvider = context.read<ReservationProvider>();
    final accommodationProvider = context.read<AccommodationProvider>();

    reservationProvider.clearBookerInfo();
    accommodationProvider.resetSearchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 뒤로가기 완전 차단
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // ── 스크롤 영역 ──
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 80, // 버튼 영역 확보
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  color: AppColors.main,
                                ),
                              ),
                            ),
                            const Icon(
                              AppIcons.check,
                              size: 80,
                              color: AppColors.main,
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
                              color: AppColors.main,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            '예약 확인',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Spacer 대신 여유 공간

                      const Divider(thickness: 1, color: Color(0xFFC1C1C1)),
                    ],
                  ),
                ),
              ),

              // ── 하단 버튼 고정 ──
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: BottomActionButton(
                  label: "메인으로 돌아가기",
                  onPressed: () => context.push(RoutePaths.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
