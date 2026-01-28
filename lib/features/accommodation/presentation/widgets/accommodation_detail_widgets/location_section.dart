import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSection extends StatelessWidget {
  final String address;
  final double mapHeight;

  const LocationSection({
    super.key,
    required this.address,
    required this.mapHeight,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('주소가 복사되었습니다'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '숙소 위치',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                  'assets/images/accommodation/address.svg',
                  width: 16,
                  height: 14
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                      fontSize: 14
                  )
                )
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: Icon(
                  Icons.copy,
                  size: 18
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: mapHeight,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.map,
                  color: Colors.grey,
                  size: 40
                )
              ),
              // 추후 실제 구글맵이나 카카오맵 위젯으로 교체 가능
            ),
          ),
        ],
      ),
    );
  }
}