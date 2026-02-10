import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/common_back_button.dart';
import 'package:provider/provider.dart';
import 'action_buttons.dart';

class AccommodationImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final int accommodationId;
  final int initialIndex;

  const AccommodationImageSlider({
    super.key,
    required this.imageUrls,
    required this.accommodationId,
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

    print('=== AccommodationImageSlider 초기화 ===');
    print('이미지 URL 개수: ${widget.imageUrls.length}');
    if (widget.imageUrls.isEmpty) {
      print('️이미지 URL 리스트가 비어있습니다!');
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
                print('이미지 없음 - placeholder 표시');
                return Container(
                  color: AppColors.gray4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                            AppIcons.notSupportedImage,
                            size: AppIcons.sizeXxxxl,
                            color: AppColors.gray3
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                            '등록된 이미지가 없습니다',
                            style: TextStyle(color: AppColors.gray3)
                        ),
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
                      print('이미지 로딩 완료 [$index]');
                      return child;
                    }

                    final progress = loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null;

                    print('⏳ 이미지 로딩 중 [$index]: ${(progress ?? 0) * 100}%');

                    return Center(
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.gray2,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.menuSelected),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ 이미지 로딩 실패 [$index]');
                    print('URL: $imageUrl');
                    print('에러: $error');
                    print('스택트레이스: $stackTrace');

                    return Container(
                      color: AppColors.gray4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(AppIcons.brokenImage, color: AppColors.gray3, size: AppIcons.sizeXxxl),
                          const SizedBox(height: AppSpacing.sm),
                          const Text(
                            '이미지를 불러올 수 없습니다',
                              style: AppTextStyles.subTitleGrey
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            child: Text(
                              imageUrl,
                              style: AppTextStyles.bodyXsGray,
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
                CommonBackButton(backgroundColor: Colors.black87, iconColor: Colors.white),
                ActionButtons(accommodationId: widget.accommodationId),
              ],
            ),
          ),

          if (widget.imageUrls.isNotEmpty)
            Positioned(
              bottom: 35,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs
                ),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.imageUrls.length}',
                  style: AppTextStyles.bodySmWhite,
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

  Widget _buildArrowButton({
    required IconData icon,
    required Alignment alignment,
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Container(
          // decoration: BoxDecoration(
          //   color: Colors.black.withOpacity(0.2),
          //   shape: BoxShape.circle,
          // ),
          child: IconButton(
            icon: Icon(
                icon,
                color: AppColors.gray2,
                size: AppIcons.sizeXl,
                fontWeight: FontWeight.bold
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}