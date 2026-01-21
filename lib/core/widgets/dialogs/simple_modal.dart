import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

import '../buttons/button_widgets.dart';

// 모달
class SimpleModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onClose; // X 버튼 클릭 시 행동
  final Widget content;  // 커스텀 본문
  final String confirmLabel;

  const SimpleModal({
    super.key,
    required this.onConfirm,
    this.onClose,
    required this.content,
    required this.confirmLabel,
    });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(color: AppColors.backdrop, dismissible: true),
        Center(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: onClose ?? () => Navigator.pop(context),
                        icon: const Icon(AppIcons.close, size: AppIcons.sizeMd),
                        splashRadius: AppBorderRadius.xxxl,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(child: content),

                      const SizedBox(height: AppSpacing.xxl),

                      // 하단 확인 버튼
                      SizedBox(
                        width: double.infinity,
                        child: MediumButton(
                          label: confirmLabel,
                          onPressed: onConfirm,
                          enabled: true,
                        ),
                      ),
                    ],
                  )
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
