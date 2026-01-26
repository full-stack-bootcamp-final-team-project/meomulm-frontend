// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String price;
  final String checkInfo;
  final String imageUrl;
  final String peopleInfo;
  final List<String> facilities;
  final VoidCallback onTapReserve;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.checkInfo,
    required this.imageUrl,
    required this.peopleInfo,
    required this.facilities,
    required this.onTapReserve,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppCardStyles.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: 163,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),

          // 방 종류 + 가격 + 기준 인원
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 2), // 간격 최소화
                    Text(
                      widget.peopleInfo,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.price,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),


          // 예약 버튼 (우측 정렬)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: widget.onTapReserve,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D96CA),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '예약하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 접기/펼치기 버튼 (중앙)
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),

          // 펼쳐진 내용 (애니메이션 없이 왼쪽 정렬)
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '숙박',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.checkInfo,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '시설/서비스',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 12,
                    runSpacing: 8,
                    children: widget.facilities
                        .map((e) => FacilityItem(icon: Icons.check, label: e))
                        .toList(),
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

// 시설/서비스 아이템
class FacilityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const FacilityItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}