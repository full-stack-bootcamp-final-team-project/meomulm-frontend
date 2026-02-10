import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';

class TitleSection extends StatelessWidget {
  final String name;

  const TitleSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPressStart: (details) => _showCopyMenu(context, details.globalPosition),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  void _showCopyMenu(BuildContext context, Offset offset) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(AppIcons.copy, size: AppIcons.sizeSm),
              SizedBox(width: 8),
              Text('숙소명 복사'),
            ],
          ),
        ),
      ],
    );

    if (result == 'copy') {
      await Clipboard.setData(ClipboardData(text: name));

      if (context.mounted) {
        SnackMessenger.showMessage(
            context,
            "숙소명이 복사되었습니다.",
            bottomPadding: AppSpacing.xxxxl,
            type: ToastType.success
        );
      }
    }
  }
}