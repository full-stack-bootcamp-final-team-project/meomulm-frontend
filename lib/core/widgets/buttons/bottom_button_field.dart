import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/config/app_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
class BottomButtonField extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;

  const BottomButtonField({
    super.key,
    required this.buttonName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: ButtonButtonBarDimensions.bottomButtonBarPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: AppShadows.bottomNav,
      ),
      child: Center(
        child: SizedBox(
          width: width * 0.9,
          height: ButtonButtonBarDimensions.bottomButtonBarHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onPressed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              buttonName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
