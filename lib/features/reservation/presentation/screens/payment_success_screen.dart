import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100), // 상단 여백
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
            // 결제 완료 텍스트
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
                  debugPrint('예약 확인 클릭');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 2,
                    color: Color(0xFF9C95CA),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  '예약 확인',
                  style: TextStyle(
                    color: Color(0xFF9C95CA),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const Spacer(),
// 결제 버튼 바로 위 회색 구분선
            const Divider(thickness: 1, color: Color(0xFFC1C1C1)),
            // 메인으로 돌아가기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9D96CA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '메인으로 돌아가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

