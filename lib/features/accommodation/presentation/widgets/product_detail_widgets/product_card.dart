
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_image_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_image_slider.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_info.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';

class ProductCard extends StatefulWidget {
  final int productId;
  final String title;
  final int price; // int로 받고 ProductCard 안에서 포맷
  final String checkInfo;
  final String imageUrl;
  final String peopleInfo;
  final List<String> facilities;
  final VoidCallback onTapReserve;
  final List<ProductImage> images;
  final DateTime checkIn;
  final DateTime checkOut;

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
    required this.images,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // 가격 포맷 (콤마)
    final priceFormat = NumberFormat('#,###');
    final formattedPrice = priceFormat.format(widget.price);

    // 숙박일 계산
    final nights = widget.checkOut.difference(widget.checkIn).inDays;
    final totalPrice = widget.price * nights;
    final totalFormattedPrice = priceFormat.format(totalPrice);

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
              topRight: Radius.circular(AppBorderRadius.md),
            ),
            child: ProductImageSlider(
              imageUrl: widget.images.map((e) => e.productImageUrl).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 객실 이름 + 기준 인원
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: AppSpacing.xxs),
                Text(widget.peopleInfo,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),

          // 가격 + 예약 버튼 (우측 정렬, 아래로 살짝 이동)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.sm, // 여기서 아래로 살짝 이동
              bottom: AppSpacing.xs,
            ),
            child: Row(
              children: [
                const Spacer(),
                Text('$formattedPrice원 / 1박', style: AppTextStyles.cardTitle),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 110,
                  height: AppSpacing.xxl,
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = context.read<ReservationProvider>();
                      provider.setReservation(
                        ReservationInfo(
                          roomId: widget.productId,
                          productName: widget.title,
                          price: widget.price,
                          commaPrice: '$formattedPrice원',
                          totalPrice: totalPrice,
                          totalCommaPrice: '$totalFormattedPrice원',
                          checkInfo: widget.checkInfo,
                          peopleInfo: widget.peopleInfo,
                          days: nights,
                        ),
                      );
                      widget.onTapReserve();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onPressed,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      textAlign: TextAlign.center,
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
                  const Text('숙박', style: AppTextStyles.bodyMd),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.checkInfo, style: TextStyle(fontSize: 13, color: AppColors.gray2)),
                  const SizedBox(height: AppSpacing.md),
                  const Text('시설/서비스', style: AppTextStyles.bodyMd),
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
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.gray2)),
      ],
    );
  }
}

 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_image_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_image_slider.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_info.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';

class ProductCard extends StatefulWidget {
  final int productId;
  final String title;
  final int price;
  final String checkInfo;
  final String imageUrl;
  final String peopleInfo;
  final List<String> facilities;
  final VoidCallback onTapReserve;
  final List<ProductImage> images;
  final DateTime checkIn;
  final DateTime checkOut;

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
    required this.images,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,###');
    final formattedPrice = priceFormat.format(widget.price);

    final nights = widget.checkOut.difference(widget.checkIn).inDays;
    final totalPrice = widget.price * nights;
    final totalFormattedPrice = priceFormat.format(totalPrice);

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
              topRight: Radius.circular(AppBorderRadius.md),
            ),
            child: ProductImageSlider(
              imageUrl: widget.images.map((e) => e.productImageUrl).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 객실 이름 + 기준 인원 (좌측 상단)
          // 방 종류 + 기준 인원 (그대로 유지)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      widget.peopleInfo,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

// 가격 + 예약 버튼 (우측 고정 + 아래로 이동)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.sm, // 아래로 내리는 핵심
              bottom: AppSpacing.xs,
            ),
            child: Row(
              children: [
                const Spacer(), // 🔥 우측 고정의 핵심
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // 🔥 우측 정렬
                  children: [
                    Text(
                      '$formattedPrice원 / 1박',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SizedBox(
                      width: 110,
                      height: AppSpacing.xxl,
                      child: ElevatedButton(
                        onPressed: () {
                          final provider = context.read<ReservationProvider>();
                          provider.setReservation(
                            ReservationInfo(
                              roomId: widget.productId,
                              productName: widget.title,
                              price: widget.price,
                              commaPrice: '$formattedPrice원',
                              totalPrice: totalPrice,
                              totalCommaPrice: '$totalFormattedPrice원',
                              checkInfo: widget.checkInfo,
                              peopleInfo: widget.peopleInfo,
                              days: nights,
                            ),
                          );
                          widget.onTapReserve();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onPressed,
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
                  const Text('숙박', style: AppTextStyles.bodyLg),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.checkInfo,
                      style: TextStyle(fontSize: 16, color: AppColors.gray2)),
                  const SizedBox(height: AppSpacing.md),
                  const Text('시설/서비스', style: AppTextStyles.bodyLg),
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
        Text(label, style: TextStyle(fontSize: 16, color: AppColors.gray2)),
      ],
    );
  }
}
