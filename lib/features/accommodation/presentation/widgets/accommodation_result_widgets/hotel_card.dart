import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HotelImages(),
          const SizedBox(height: 12),
          const Text(
            '롯데 호텔 명동',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            '중구 · 을지로 입구역 도보 6분',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '230,000',
                    style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '원',
                    style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}












class _HotelImages extends StatelessWidget {
  const _HotelImages();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1, // ⭐ 이미지 묶음 비율
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.asset(
                'assets/images/makao/makao(1).jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/makao/makao(2).jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/makao/makao(3).jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
