import 'package:flutter/cupertino.dart';

class SearchRow extends StatelessWidget {
  final Widget leading;
  final Widget child;

  const SearchRow({
    super.key,
    required this.leading,
    required this.child,
  });

  static const double height = 52;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
