import 'package:flutter/material.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> imageUrl; // ✅ 매개변수 이름 통일
  final int initialIndex;

  const ProductImageSlider({
    super.key,
    required this.imageUrl,
    this.initialIndex = 0,
  });

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // 🔍 디버그: 전달받은 이미지 URL 확인
    print('=== ProductImageSlider 초기화 ===');
    print('이미지 URL 개수: ${widget.imageUrl.length}');
    if (widget.imageUrl.isEmpty) {
      print('⚠️ 경고: 이미지 URL 리스트가 비어있습니다!');
    } else {
      widget.imageUrl.asMap().forEach((index, url) {
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
    // 필요 시 클립보드 복사 기능 구현 가능
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (2 / 5);

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 이미지 슬라이더 (PageView)
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrl.isEmpty ? 1 : widget.imageUrl.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (widget.imageUrl.isEmpty) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('등록된 이미지가 없습니다',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              final imageUrl = widget.imageUrl[index];

              return GestureDetector(
                onLongPress: _copyLink,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    final progress =
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null;

                    return Center(
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image,
                              color: Colors.grey, size: 40),
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
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
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

          // 2. 사진 개수 표시 (인디케이터)
          if (widget.imageUrl.isNotEmpty)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.imageUrl.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),

          // 3. 좌우 화살표 (이미지가 2장 이상일 때만)
          if (widget.imageUrl.length > 1) ...[
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

  Widget _buildArrowButton({
    required IconData icon,
    required Alignment alignment,
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IconButton(
          icon: Icon(icon, color: Colors.grey[800], size: 28),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
