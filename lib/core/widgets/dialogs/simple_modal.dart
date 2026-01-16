import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

import '../buttons/button_widgets.dart';

// 모달
class SimpleModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onClose; // X 버튼 클릭 시 행동
  final String label;

  const SimpleModal({super.key, required this.onConfirm, this.onClose, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: AppColors.backdrop, dismissible: false),
        Center(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xl,
                horizontal: AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: onClose ?? () => Navigator.pop(context),
                        icon: const Icon(AppIcons.close, size: AppIcons.sizeMd),
                        splashRadius: AppBorderRadius.xxxl,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 하단 확인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: MediumButton(
                      label: label,
                      onPressed: () =>onConfirm,
                      enabled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
