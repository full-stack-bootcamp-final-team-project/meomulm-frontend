import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 사진 URL 복사 기능
  void _copyImageUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('이미지 주소가 복사되었습니다.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
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
            onPageChanged: (index) =>
              setState(() =>
                _currentIndex = index
              ),
            itemBuilder: (context, index) {
              if (widget.imageUrls.isEmpty) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              }

              return GestureDetector(
                onLongPress: () => _copyImageUrl(widget.imageUrls[index]), // 길게 누르면 복사
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        SizedBox(height: 8),
                        Text('이미지를 불러올 수 없습니다', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. 상단 버튼 바 (뒤로가기, 좋아요, 공유)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8, // 상태바 대응
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonBackButton(
                  backgroundColor: Colors.black26, // 약간 투명한 검정
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
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          // 4. 좌우 화살표 내비게이션 (이미지가 2장 이상일 때만 표시)
          if (widget.imageUrls.length > 1) ...[
            _buildArrowButton(
              icon: Icons.chevron_left,
              alignment: Alignment.centerLeft,
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
            _buildArrowButton(
              icon: Icons.chevron_right,
              alignment: Alignment.centerRight,
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
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
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 28),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}