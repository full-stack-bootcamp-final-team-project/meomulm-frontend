import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final String? label;
  final String value;
  const IconTextRow({this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.circle, size: 6),
    const SizedBox(width: 8),
    Text(label != null ? '$label: $value' : value),
  ]);
}