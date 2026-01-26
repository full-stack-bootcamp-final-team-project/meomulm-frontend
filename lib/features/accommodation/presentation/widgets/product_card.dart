/*
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
*/

// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_info.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';

class ProductCard extends StatefulWidget {
  final int productId; // roomId 추가
  final String title;
  final String price;
  final String checkInfo;
  final String imageUrl;
  final String peopleInfo;
  final List<String> facilities;
  final VoidCallback onTapReserve;

  const ProductCard({
    super.key,
    required this.productId,
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
                topLeft: Radius.circular(AppBorderRadius.md),
                topRight: Radius.circular(AppBorderRadius.md)),
            child: Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: 163,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 방 종류 + 가격 + 기준 인원
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      widget.peopleInfo,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.price,
                  style: AppTextStyles.cardTitle,
                ),
              ],
            ),
          ),

          // 예약 버튼 (우측 정렬)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: AppSpacing.xxl,
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = context.read<ReservationProvider>(); // Provider 가져오기

                      provider.setReservation(
                        ReservationInfo(
                          roomId: widget.productId,
                          accommodationName: widget.title, // 숙소 이름
                          roomType: widget.title, // 방 종류
                          baseCapacity: widget.peopleInfo, // 기준인원 추출
                          price: widget.price,
                        ),
                      );

                      final res = provider.reservation;
                      debugPrint('저장된 예약 정보: ${res?.roomId}, ${res?.accommodationName}, ${res?.roomType}, ${res?.baseCapacity}, ${res?.price}');
                      widget.onTapReserve(); // 화면 이동
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onPressed,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
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

          const SizedBox(height: AppBorderRadius.sm),

          // 접기/펼치기 버튼
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
                size: AppIcons.sizeXl,
              ),
            ),
          ),

          // 펼쳐진 내용
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: AppBorderRadius.xl,
                  right: AppBorderRadius.xl,
                  bottom: AppBorderRadius.lg,
                  top: AppBorderRadius.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '숙박',
                    style: AppTextStyles.bodyMd,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.checkInfo,
                    style: TextStyle(fontSize: 13, color: AppColors.gray2),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    '시설/서비스',
                    style: AppTextStyles.bodyMd,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
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
        Icon(icon, size: AppIcons.sizeXs, color: AppColors.black),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.gray2),
        ),
      ],
    );
  }
}

