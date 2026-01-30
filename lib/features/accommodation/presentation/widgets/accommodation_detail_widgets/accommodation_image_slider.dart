import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_map_widgets/common_back_button.dart';
import 'package:provider/provider.dart';
import 'action_buttons.dart';

class AccommodationImageSlider extends StatefulWidget {
  final List<String> imageUrls;
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

    // 🔍 디버그: 전달받은 이미지 URL 확인
    print('=== AccommodationImageSlider 초기화 ===');
    print('이미지 URL 개수: ${widget.imageUrls.length}');
    if (widget.imageUrls.isEmpty) {
      print('⚠️ 경고: 이미지 URL 리스트가 비어있습니다!');
    } else {
      widget.imageUrls.asMap().forEach((index, url) {
        print('이미지 [$index]: $url');
      });
    }
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _copyLink() {

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (3 / 5);

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 이미지 슬라이더 (PageView)
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.isEmpty
                ? 1
                : widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              print('페이지 변경: $index');
            },
            itemBuilder: (context, index) {
              if (widget.imageUrls.isEmpty) {
                print('⚠️ 이미지 없음 - placeholder 표시');
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('등록된 이미지가 없습니다', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              final imageUrl = widget.imageUrls[index];
              print('이미지 빌드 시도 [$index]: $imageUrl');

              return GestureDetector(
                onLongPress: () => _copyLink(),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      print('✅ 이미지 로딩 완료 [$index]');
                      return child;
                    }

                    final progress = loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null;

                    print('⏳ 이미지 로딩 중 [$index]: ${(progress ?? 0) * 100}%');

                    return Center(
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ 이미지 로딩 실패 [$index]');
                    print('URL: $imageUrl');
                    print('에러: $error');
                    print('스택트레이스: $stackTrace');

                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            '이미지를 불러올 수 없습니다',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              imageUrl,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // 2. 상단 버튼 바 (뒤로가기, 좋아요, 공유)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 6,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonBackButton(
                  backgroundColor: Colors.black87,
                  iconColor: Colors.white,
                ),
                Consumer<AccommodationProvider>(
                  builder: (context, provider, child) {
                    // provider에 저장된 id를 쓰거나, Screen에서 넘겨받은 id를 쓰도록 설계
                    final id = provider.selectedAccommodationId ?? 0;
                    return ActionButtons(accommodationId: id);
                  },
                ),
              ],
            ),
          ),

          // 3. 사진 개수 표시 (인디케이터)
          if (widget.imageUrls.isNotEmpty)
            Positioned(
              bottom: 35, // 상세 정보 컨테이너 곡선(translate -20) 고려
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.imageUrls.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),

          // 4. 좌우 화살표 내비게이션 (이미지가 2장 이상일 때만 표시)
          if (widget.imageUrls.length > 1) ...[
            _buildArrowButton(
                icon: Icons.chevron_left,
                alignment: Alignment.centerLeft,
                onPressed: () {
                  print('이전 이미지로 이동');
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
            ),
            _buildArrowButton(
              icon: Icons.chevron_right,
              alignment: Alignment.centerRight,
              onPressed: () {
                print('다음 이미지로 이동');
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // 화살표 버튼 헬퍼
  Widget _buildArrowButton({
    required IconData icon,
    required Alignment alignment,
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          // decoration: BoxDecoration(
          //   color: Colors.black.withOpacity(0.2),
          //   shape: BoxShape.circle,
          // ),
          child: IconButton(
            icon: Icon(icon, color: Colors.grey[800], size: 28, fontWeight: FontWeight.bold),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}