import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

// =====================
// 프로필 이미지 영역
// =====================
class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onCameraTap;

  const ProfileAvatar({this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              // TODO: 프로필 이미지로 영역 채우기
              color: AppColors.gray5,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gray4),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: InkWell(
              onTap: onCameraTap,  // TODO: 카메라 아이콘 터치 시 작동하는 기능 변수 넣기
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.gray5,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gray4),
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.camera,
                    size: AppIcons.sizeXs,
                    color: AppColors.gray2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}