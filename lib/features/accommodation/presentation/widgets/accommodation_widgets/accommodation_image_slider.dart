import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_map_widgets/common_back_button.dart';
import 'package:provider/provider.dart';

import 'action_buttons.dart';

class AccommodationImageSlider extends StatefulWidget {
  final List<String> imageUrls; // 여러 장 이미지 URL 리스트
  final int initialIndex;

  const AccommodationImageSlider({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<AccommodationImageSlider> createState() => _AccommodationImageSliderState();
}

class _AccommodationImageSliderState extends State<AccommodationImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (3 / 5);
    return SizedBox(
      // height: 231,
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 이미지 슬라이더
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              // return Image.network(
              //   widget.imageUrls[index],
              //   fit: BoxFit.cover,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return const Center(child: CircularProgressIndicator());
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return const Center(child: Icon(Icons.error, color: Colors.red));
              //   },
              // );
              return Image.asset(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                // asset은 로딩이 매우 빠르지만, 안전하게 placeholder 유지
                // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                //   if (wasSynchronouslyLoaded) return child;
                //   return const Center(child: CircularProgressIndicator());
                // },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image, color: Colors.red, size: 48),
                        SizedBox(height: 8),
                        Text('이미지 로드 실패', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          // 뒤로가기 버튼
          Positioned(
            top: 5,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 왼쪽: 뒤로가기 버튼
                const CommonBackButton(
                  backgroundColor: Color(0xFF303030),
                  iconColor: Colors.white,
                ),

                // 오른쪽: 좋아요 + 공유 버튼들
                // ActionButtons(),
                Consumer<AccommodationProvider>(
                  builder: (context, provider, child) {
                    final id = provider.currentId ?? 'unknown';
                    return ActionButtons(accommodationId: id);
                  },
                ),
              ],
            ),
          ),

          // 사진 개수 표시 (오른쪽 하단)
          Positioned(
            bottom: 31,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.imageUrls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),

          // 왼쪽 화살표
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.30),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ),

          // 오른쪽 화살표 (대칭)
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.30),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}