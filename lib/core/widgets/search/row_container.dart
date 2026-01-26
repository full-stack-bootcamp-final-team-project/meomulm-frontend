import 'package:flutter/material.dart';

class RowContainer extends StatelessWidget {
  final Widget child;
  static const double height = 52;

  const RowContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: child,
    );
  }
}
