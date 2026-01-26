import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';

import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/icon_menu_button.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/menu_item.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/profile_avatar.dart';

/**
 * 마이페이지 스크린 - only_app_style : 수정 필요.
 */
class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  // =====================
  // 로그아웃 확인 모달
  // =====================
  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return SimpleModal(
            onConfirm: () {
              // TODO: 로그인 기능 구현
            },
            content: Text(DialogMessages.logoutContent),
            confirmLabel: ButtonLabels.confirm,
        );
      },
    );
  }

  // =====================
  // 회원탈퇴 확인 모달
  // =====================
  Future<void> _showWithdrawDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return SimpleModal(
          onConfirm: () {
            // TODO: 회원탈퇴 API 호출 구현 - service 호출
            // TODO: 탈퇴 완료 후 이동 기능 구현
            // context.go('/');
          },
          content: Text("탈퇴를 진행하시겠습니까?"),  // TODO: 상수 추가
          confirmLabel: "탈퇴",
        );
      },
    );
  }

  // =====================
  // TODO: 카메라 버튼 클릭 시 기능
  // =====================


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? screenWidth : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: TitleLabels.myInfo),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppBorderRadius.xxl,
                vertical: AppBorderRadius.lg
            ),
            children: [
              const SizedBox(height: AppSpacing.xl),

              // =====================
              // 프로필 영역
              // =====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatar(
                      onCameraTap: () {
                        // TODO: 카메라 아이콘 터치 시 작동하는 기능 변수 넣기
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'gangster@exam.com', // TODO: 회원 이메일로 바꾸기
                            style: AppTextStyles.buttonLg,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            '홍길동',  // TODO: 회원 이름으로 바꾸기
                            style: AppTextStyles.bodyLg
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // =====================
              // 아이콘 메뉴
              // =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: IconMenuButton(
                      icon: AppIcons.favoriteRounded,
                      label: TitleLabels.wishlist,
                      onTap: () {
                        context.push('${RoutePaths.myPage}${RoutePaths.favorite}');  // /mypage/favorite
                      },
                    ),
                  ),
                  Expanded(
                    child: IconMenuButton(
                      icon: AppIcons.commentOutline,
                      label: TitleLabels.myReviews,
                      onTap: () {
                        context.push('${RoutePaths.myPage}${RoutePaths.myReview}');  // /mypage/review
                      },
                    ),
                  ),
                  Expanded(
                    child: IconMenuButton(
                      icon: AppIcons.calendarMonth,
                      label: TitleLabels.myBookings,
                      onTap: () {
                        context.push('${RoutePaths.myPage}${RoutePaths.myReservation}');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(color: AppColors.gray3, height: AppBorderWidth.md),
              const SizedBox(height: AppSpacing.md),

              // =====================
              // 하단 메뉴 리스트
              // =====================
              MenuItem(
                title: TitleLabels.editProfile,
                onTap: () {
                  context.push('${RoutePaths.myPage}${RoutePaths.editProfile}'); // /profile/edit
                },
              ),
              MenuItem(
                title: TitleLabels.mypageChangePassword,
                onTap: () {
                  context.push('${RoutePaths.myPage}${RoutePaths.myPageChangePassword}');  // /change-password
                },
              ),
              MenuItem(
                title: '로그아웃',
                onTap: () => _showLogoutDialog(context),
              ),
              MenuItem(
                title: '회원탈퇴',
                textColor: AppColors.cancelled,
                onTap: () => _showWithdrawDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//---------------------- TODO : 이 아래 위젯으로 분리하기 ----------------------





