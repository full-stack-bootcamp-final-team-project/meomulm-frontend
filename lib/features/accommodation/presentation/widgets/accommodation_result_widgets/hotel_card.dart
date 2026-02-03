import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 천 단위 콤마용 (pubspec.yaml에 intl 추가 필수)
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';

import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:provider/provider.dart';

/*
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
*/

/*
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
*/


class HotelCard extends StatelessWidget {
  final SearchAccommodationResponseModel accommodation;

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
          provider.setAccommodationInfo(
            accommodationId ?? 0,
            accommodation.accommodationName ?? '',
          );
          context.push('/accommodation-detail/$accommodationId');
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
              _HotelImages(accommodation: accommodation),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                              '원 (1박)',
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
  final SearchAccommodationResponseModel accommodation;

  const _HotelImages({required this.accommodation});

  static const _defaultImages = [
    'assets/images/accommodation/default_accommodation_image(1).jpg',
    'assets/images/accommodation/default_accommodation_image(2).jpg',
    'assets/images/accommodation/default_accommodation_image(3).jpg',
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint(
        (accommodation.accommodationImages ?? [])
            .map((e) => e.accommodationImageUrl ?? 'null')
            .toList()
            .toString()
    );


    final dbImages = (accommodation.accommodationImages ?? [])
        .where((e) => e.accommodationImageUrl != null && e.accommodationImageUrl!.isNotEmpty)
        .toList();

    if (dbImages.isEmpty) {
      return _ThreeImageLayout(
        images: _defaultImages.map((e) => _ImageSource.asset(e)).toList(),
      );
    }

    if (dbImages.length == 1) {
      debugPrint("사진 1장 감지: ${dbImages[0].accommodationImageUrl}");
      return _SingleImage(
        image: _ImageSource.network(dbImages[0].accommodationImageUrl!),
      );
    }

    if (dbImages.length == 2) {
      return _TwoImageLayout(
        left: _ImageSource.network(dbImages[0].accommodationImageUrl!),
        right: _ImageSource.network(dbImages[1].accommodationImageUrl!),
      );
    }

    // 3장 이상 → 앞 3장만
    return _ThreeImageLayout(
      images: dbImages
          .take(3)
          .map((e) => _ImageSource.network(e.accommodationImageUrl!))
          .toList(),
    );
  }
}

/// 1장
class _SingleImage extends StatelessWidget {
  final _ImageSource image;

  const _SingleImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8, // ← 2장, 3장 레이아웃과 동일하게 맞춤
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: _ImageView(source: image),
      ),
    );
  }
}

/// 2장
class _TwoImageLayout extends StatelessWidget {
  final _ImageSource left;
  final _ImageSource right;

  const _TwoImageLayout({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
              child: _ImageView(source: left),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
              child: _ImageView(source: right),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3장
class _ThreeImageLayout extends StatelessWidget {
  final List<_ImageSource> images;

  const _ThreeImageLayout({required this.images});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
              child: _ImageView(source: images[0]),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                    child: _ImageView(source: images[1]),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
                    child: _ImageView(source: images[2]),
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

// class _ImageView extends StatelessWidget {
//   final _ImageSource source;
//
//   const _ImageView({required this.source});
//
//   @override
//   Widget build(BuildContext context) {
//     return source.isNetwork
//         ? Image.network(
//       source.path,
//       fit: BoxFit.cover,
//       errorBuilder: (_, __, ___) =>
//       const _BrokenImagePlaceholder(),
//       loadingBuilder: (context, child, progress) {
//         if (progress == null) return child;
//         return const Center(
//           child: CircularProgressIndicator(strokeWidth: 2),
//         );
//       },
//     )
//         : Image.asset(
//       source.path,
//       fit: BoxFit.cover,
//     );
//   }
// }

// class _ImageView extends StatelessWidget {
//   final _ImageSource source;
//
//   const _ImageView({required this.source});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         image: DecorationImage(
//           image: source.isNetwork
//               ? NetworkImage(source.path)
//               : AssetImage(source.path) as ImageProvider,
//           fit: BoxFit.cover,
//           onError: (_, __) {},
//         ),
//       ),
//     );
//   }
// }

class _ImageSource {
  final String path;
  final bool isNetwork;

  _ImageSource.network(this.path) : isNetwork = true;
  _ImageSource.asset(this.path) : isNetwork = false;
}

class _ImageView extends StatelessWidget {
  final _ImageSource source;

  const _ImageView({required this.source});

  @override
  Widget build(BuildContext context) {
    if (source.isNetwork) {
      return Image.network(
        source.path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image_outlined, size: 36, color: Colors.grey),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    } else {
      return Image.asset(
        source.path,
        fit: BoxFit.cover,
      );
    }
  }
}
