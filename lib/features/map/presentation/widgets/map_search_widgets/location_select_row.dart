import 'package:flutter/material.dart';

class LocationSelectRow extends StatelessWidget {
  final String location;
  final VoidCallback onTap;

  const LocationSelectRow({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                location.isEmpty ? '지역 선택' : location,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: location.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}