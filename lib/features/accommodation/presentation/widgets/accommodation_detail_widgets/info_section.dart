import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'icon_text_row.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'icon_text_row.dart';

class InfoSection extends StatelessWidget {
  final String? contact;

  const InfoSection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // 1. 데이터 정제: <br>, /, , 등을 기준으로 리스트화
    final List<String> contactList = (contact == null || contact!.isEmpty)
        ? []
        : contact!
        .split(RegExp(r'<br>|,|/|(?<=\d)\s(?=\d)'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              '숙소 정보',
              style: AppTextStyles.cardTitle
          ),
          const SizedBox(height: AppSpacing.lg),
          if (contactList.isEmpty)
            const IconTextRow(
                label: '연락처',
                value: "등록되지 않은 업체입니다."
            )
          else
            ...contactList.map((number) => GestureDetector(
              onLongPressStart: (details) => _showContextMenu(context, details.globalPosition, number),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: IconTextRow(label: '연락처', value: number),
              ),
            )),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset offset, String number) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        const PopupMenuItem(
            value: 'copy',
            child: ListTile(
                leading: Icon(AppIcons.copy),
                title: Text('복사하기')
            )
        ),
        const PopupMenuItem(
            value: 'call',
            child: ListTile(
                leading: Icon(AppIcons.phone),
                title: Text('전화걸기')
            )
        ),
      ],
    );

    if (result == 'copy') {
      await Clipboard.setData(ClipboardData(text: number));
      // if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('복사되었습니다.')));
      if (context.mounted) SnackMessenger.showMessage(
          context,
          "연락처가 복사되었습니다.",
          bottomPadding: AppSpacing.xxxxl,
          type: ToastType.success
      );
    } else if (result == 'call') {
      final Uri url = Uri(scheme: 'tel', path: number);
      if (await canLaunchUrl(url)) await launchUrl(url);
    }
  }
}