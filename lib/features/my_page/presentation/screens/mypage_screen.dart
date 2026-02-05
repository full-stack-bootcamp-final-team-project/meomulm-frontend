import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';

import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/cloudinary_service.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/mypage_service.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/icon_menu_button.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/menu_item.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/mypage/profile_avatar.dart';
import 'package:provider/provider.dart';

/**
 * 마이페이지 스크린 - only_app_style : 수정 필요.
 */
class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  final cloudinaryUploader = CloudinaryUploader();
  final mypageService = MypageService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<UserProfileProvider>().loadUserProfile(token);
      } else {
        context.go(ApiPaths.loginUrl);
      }
    });
  }

  // =====================
  // 로그아웃 확인 모달
  // =====================
  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return SimpleModal(
          onConfirm: () async {
            await context.read<AuthProvider>().logout();
            context.go(RoutePaths.login);
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
          onConfirm: _userWithdrawal,
          content: Text("탈퇴를 진행하시겠습니까?"),
          confirmLabel: "탈퇴",
        );
      },
    );
  }

  // 카메라 클릭 시 이미지 선택
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked == null) return;
    final original = File(picked.path);

    _uploadProfileImage(original);
  }

  // 프로필 업로드 함수 호출
  Future<void> _uploadProfileImage(File file) async {
    final token = context.read<AuthProvider>().token;
    if(token == null) return;

    setState(() => isLoading = true);

    try {
      // Cloudinary 업로드
      final imageUrl = await cloudinaryUploader.uploadImage(file);

      // 백엔드에 저장
      await mypageService.uploadProfileImage(token, imageUrl);

      // 프로필 다시 불러오기
      await context.read<UserProfileProvider>().loadUserProfile(token);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지 업로드 실패: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 회원탈퇴 함수 호출
  Future<void> _userWithdrawal() async {
    setState(() => isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      if(token == null) return;

      await mypageService.userWithdrawal(token);
      await context.read<AuthProvider>().logout();
      context.go(RoutePaths.home);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("회원 탈퇴에 실패했습니다."),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider  가져오기
    final provider = context.watch<UserProfileProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? screenWidth : double.infinity;

    // TODO: 공통 로딩 UI가 있으면 변경하기
    if(provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    // 유저 정보 가져오기
    final user = provider.user!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: TitleLabels.myInfo,
        onBack: () => context.go('/home'),
      ),
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
                      onCameraTap: _pickImage,
                      profileImageUrl: user.userProfileImage ?? null,
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.userEmail,
                            style: AppTextStyles.bodyXl,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            user.userName,
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
                        context.push('${RoutePaths.myPage}${RoutePaths.myReservation}?tab=0');
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
                  context.push('${RoutePaths.myPage}${RoutePaths.editProfile}', extra: user); // /profile/edit
                },
              ),
              MenuItem(
                title: TitleLabels.mypageChangePassword,
                onTap: () {
                  context.push('${RoutePaths.myPage}${RoutePaths.myPageChangePassword}', extra: user);  // /change-password
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
