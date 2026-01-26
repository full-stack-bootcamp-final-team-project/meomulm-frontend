import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonBackButton extends StatelessWidget {
  /// 버튼 배경색
  final Color backgroundColor;

  /// 아이콘 색
  final Color iconColor;

  /// 클릭 시 동작 (나중에 context.pop / context.go 주입)
  final VoidCallback? onTap;

  const CommonBackButton({
    super.key,
    this.backgroundColor = const Color(0xFF303030),
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

