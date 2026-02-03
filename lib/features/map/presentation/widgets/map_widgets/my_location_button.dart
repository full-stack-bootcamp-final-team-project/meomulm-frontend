import 'package:flutter/material.dart';

/// 내 위치로 이동하는 버튼 (LayoutBuilder 사용)
class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasSelectedAccommodation;

  const MyLocationButton({
    super.key,
    required this.onPressed,
    this.hasSelectedAccommodation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 0,
      child: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            bottom: hasSelectedAccommodation ? 380.0 : 16.0,
          ),
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 4,
            child: const Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}