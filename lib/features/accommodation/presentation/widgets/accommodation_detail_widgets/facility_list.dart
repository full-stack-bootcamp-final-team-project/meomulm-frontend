import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

class FacilityList extends StatefulWidget {
  final int initialShowCount;
  final List<String> facilities;
  const FacilityList({required this.initialShowCount, required this.facilities});
  @override
  State<FacilityList> createState() => _FacilityListState();
}

class _FacilityListState extends State<FacilityList> {
  bool _showAll = false;
  @override
  Widget build(BuildContext context) {
    final items = _showAll ? widget.facilities : widget.facilities.take(widget.initialShowCount).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.lg, runSpacing: AppSpacing.md,
          children: items.map((item) => SizedBox(
            width: (MediaQuery.of(context).size.width - 60) / 2,
            child: Row(
                children: [
                  const Icon(AppIcons.check, size: AppIcons.sizeXs),
                  const SizedBox(width: AppSpacing.xs), Text(item)
                ]
            ),
          )).toList(),
        ),
        if (widget.facilities.length > widget.initialShowCount && !_showAll)
          TextButton(onPressed: () => setState(() => _showAll = true), child: const Text('더보기 +')),
      ],
    );
  }
}