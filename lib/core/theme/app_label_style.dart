import 'package:flutter/material.dart';

class AppLabelStyle extends StatelessWidget{
  final String? label;
  final bool isRequired;

  AppLabelStyle({
    this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != null)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 2),
                const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),

        if (label != null) const SizedBox(height: 2),
      ],
    );
  }
}