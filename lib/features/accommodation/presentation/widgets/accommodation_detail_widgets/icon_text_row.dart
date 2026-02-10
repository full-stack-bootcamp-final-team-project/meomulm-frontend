import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

class IconTextRow extends StatelessWidget {
  final String? label;
  final String value;
  const IconTextRow({this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(AppIcons.circle, size: AppIcons.sizeXxxs),
    const SizedBox(width: AppSpacing.sm),
    Text(label != null ? '$label: $value' : value),
  ]);
}