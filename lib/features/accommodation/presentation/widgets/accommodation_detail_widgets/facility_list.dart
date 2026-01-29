import 'package:flutter/material.dart';

class FacilityList extends StatefulWidget {
  final int initialShowCount;
  final List<String> facilities; // 리스트 받음
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
          spacing: 16, runSpacing: 12,
          children: items.map((item) => SizedBox(
            width: (MediaQuery.of(context).size.width - 60) / 2,
            child: Row(children: [const Icon(Icons.check, size: 16), const SizedBox(width: 4), Text(item)]),
          )).toList(),
        ),
        if (widget.facilities.length > widget.initialShowCount && !_showAll)
          TextButton(onPressed: () => setState(() => _showAll = true), child: const Text('더보기 +')),
      ],
    );
  }
}