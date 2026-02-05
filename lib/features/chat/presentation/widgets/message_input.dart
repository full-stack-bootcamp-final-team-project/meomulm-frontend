import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback onSend;
  final bool isLoading;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: controller,
                enabled: !isLoading,

                // 입력 텍스트 색
                style: TextStyle(
                  color: isLoading
                      ? AppColors.gray3  // 비활성화 텍스트 색
                      : AppColors.gray1, // 활성화 텍스트 색
                ),

                decoration: InputDecoration(
                  hintText: '메세지 입력',
                  filled: true,

                  // 배경색 (상태별)
                  fillColor: isLoading
                      ? AppColors.gray5  // 비활성화 배경
                      : AppColors.white, // 활성화 배경

                  // 기본 상태 보더
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    borderSide: const BorderSide(
                      color: AppColors.gray4, // 기본 보더 색
                      width: 1,
                    ),
                  ),

                  // 포커스 됐을 때 보더
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    borderSide: const BorderSide(
                      color: AppColors.main, // 포커스 시 보더 색
                      width: 2,
                    ),
                  ),

                  // 비활성화 상태
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    borderSide: const BorderSide(
                      color: AppColors.gray5,
                    ),
                  ),
                ),
                onSubmitted: (_) => onSend()),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: isLoading ? null : onSend,
            icon: const Icon(Icons.send),
            color: AppColors.main,           // 활성화 색
            disabledColor: AppColors.gray4,  // 비활성화 색
          )
        ],
      ),
    );
  }
}