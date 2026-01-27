import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 천 단위 콤마용 (pubspec.yaml에 intl 추가 필수)

import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:provider/provider.dart';

class HotelCard extends StatelessWidget {
  final Accommodation accommodation;

  const HotelCard({
    super.key,
    required this.accommodation,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AccommodationProvider>();

    final priceFormat = NumberFormat('#,###');

    final name = accommodation.accommodationName ?? '숙소명 없음';
    final address = accommodation.accommodationAddress ?? '주소 정보 없음';
    final minPrice = accommodation.minPrice;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          final accommodationId = accommodation.accommodationId;
          provider.setAccommodation(
              accommodation.accommodationId ?? 0,
              accommodation.accommodationName ?? "");
          context.go('/accommodation-detail/$accommodationId');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 영역
              _HotelImages(accommodation: accommodation),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 숙소 이름
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 주소
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // 가격 영역 (오른쪽 정렬)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (minPrice != null) ...[
                            Text(
                              priceFormat.format(minPrice),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE53935),
                              ),
                            ),
                            const Text(
                              '원',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ] else
                            const Text(
                              '가격 정보 없음',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotelImages extends StatelessWidget {
  final Accommodation accommodation;

  const _HotelImages({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    final images = accommodation.accommodationImages ?? [];

    if (images.isEmpty) {
      return Container(
        height: 180,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    }

    // 1장만 있을 때 → 전체 화면으로 크게
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            images.first.accommodationImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            },
          ),
        ),
      );
    }

    // 2장 이상 → 1(큰) + 2(작은) 레이아웃
    return AspectRatio(
      aspectRatio: 2.1,
      child: Row(
        children: [
          // 왼쪽 큰 이미지
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
              child: Image.network(
                images.first.accommodationImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _BrokenImagePlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                },
              ),
            ),
          ),
          const SizedBox(width: 3),

          // 오른쪽 작은 이미지 2개
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                    child: images.length >= 2
                        ? Image.network(
                      images[1].accommodationImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _BrokenImagePlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    )
                        : const _EmptyImagePlaceholder(),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
                    child: images.length >= 3
                        ? Image.network(
                      images[2].accommodationImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _BrokenImagePlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    )
                        : const _EmptyImagePlaceholder(),
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

// 재사용 가능한 placeholder 위젯
class _BrokenImagePlaceholder extends StatelessWidget {
  const _BrokenImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.broken_image_outlined, size: 36, color: Colors.grey),
      ),
    );
  }
}

class _EmptyImagePlaceholder extends StatelessWidget {
  const _EmptyImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey.shade300);
  }
}