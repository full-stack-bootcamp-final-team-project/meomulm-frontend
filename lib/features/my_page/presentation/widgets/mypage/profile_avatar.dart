import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

// =====================
// 프로필 이미지 영역
// =====================
class ProfileAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final Function()? onCameraTap;
  final bool isLoading;

  const ProfileAvatar({
    this.onCameraTap,
    this.profileImageUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isImageExists =
        profileImageUrl != null && profileImageUrl!.trim().isNotEmpty;
    const double size = 64;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.gray5,
                  backgroundImage: isImageExists
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? const Icon(
                          Icons.person,
                          size: size * 0.6,
                          color: AppColors.gray2,
                        )
                      : null,
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.gray5,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                Positioned(
                  right: -4,
                  bottom: -2,
                  child: GestureDetector(
                    onTap: onCameraTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      // TODO: 공통상수로 변경하기
                      decoration: BoxDecoration(
                        color: AppColors.gray5,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gray4),
                      ),
                      child: Icon(
                        AppIcons.camera,
                        size: AppIcons.sizeXs,
                        color: AppColors.gray2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
