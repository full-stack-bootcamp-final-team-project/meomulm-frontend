import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final ScrollController _adScroll = ScrollController();
  static final ScrollController _recentScroll = ScrollController();
  static final ScrollController _seoulScroll = ScrollController();
  static final ScrollController _jejuScroll = ScrollController();
  static final ScrollController _busanScroll = ScrollController();

  // 가데이터
  static final List<Map<String, String>> dummyItems = List.generate(12, (index) => {
    "title": "라발스 호텔 부산 ${index + 1}",
    "price": "86,660원 ~",
    "img": "https://picsum.photos/id/${index + 10}/400/600",
  });

  Map<String, dynamic> _getGradientSettings() {
    final hour = DateTime.now().hour;

    if (hour >= 3 && hour < 9) {
      return {
        "colors": [const Color(0xFF5699CD), const Color(0xFFFFECC9)],
        "stops": [0.0, 0.6],
      };
    } else if (hour >= 9 && hour < 17) {
      return {
        "colors": [const Color(0xFF91CFFF), const Color(0xFFE7EFF0)],
        "stops": [0.0, 0.6],
      };
    } else if (hour >= 17 && hour < 21) {
      return {
        "colors": [const Color(0xFFA7A6CB), const Color(0xFFE56E50)],
        "stops": [0.0, 1.0],
      };
    } else {
      return {
        "colors": [const Color(0xFF3A586E), const Color(0xFF4C1D47)],
        "stops": [0.0, 0.5],
      };
    }
  }

  void _scrollByItem(
      ScrollController controller,
      double itemWidth,
      double spacing,
      bool isLeft,
      )
  {
    final step = itemWidth + spacing;

    final targetOffset =
        controller.offset + (isLeft ? -step : step);

    final clampedOffset = targetOffset.clamp(
      0.0,
      controller.position.maxScrollExtent,
    );

    controller.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradientSettings();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final headerHeight = height * 0.16;
          final adHeight = width * 0.25;
          final sectionHeight = width * 0.5;
          final bottomBarHeight = height * 0.09;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: const Alignment(0, -0.2),
                colors: gradient["colors"],
                stops: gradient["stops"],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      _buildHeader(),
                      Positioned.fill(
                        top: headerHeight,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppBorderRadius.xxl),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildAdSection(adHeight, width),
                                _buildSection(
                                  width,
                                  sectionHeight,
                                  "최근 본 숙소",
                                  false,
                                  _recentScroll,
                                ),
                                _buildSection(
                                  width,
                                  sectionHeight,
                                  "서울",
                                  true,
                                  _seoulScroll,
                                ),
                                _buildSection(
                                  width,
                                  sectionHeight,
                                  "제주",
                                  true,
                                  _jejuScroll,
                                ),
                                _buildSection(
                                  width,
                                  sectionHeight,
                                  "부산",
                                  true,
                                  _busanScroll,
                                ),
                                // 하단 여백
                                SizedBox(height: AppSpacing.xl),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomBar(bottomBarHeight),
              ],
            ),
          );
        },
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Positioned(
      top: AppSpacing.xxxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          // 로고
          Image.asset(
            'assets/images/main_logo.png',
            width: 60,
            height: 48,
            fit: BoxFit.contain,
            // 이미지가 없을 때 에러 방지를 위한 처리
            errorBuilder: (context, error, stackTrace) {
              return Text(
                  '머묾',
                  style: AppTextStyles.appBarTitle.copyWith(
                    color: Colors.white,
                  ),
              );
            },
          ),
          // 알림
          Icon(
              AppIcons.notifications,
              color: AppColors.white,
              size: AppIcons.sizeXxl
          ),
        ],
      ),
    );
  }

  // AD SECTION
  Widget _buildAdSection(double height, double width) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemCount = dummyItems.length;

    final itemWidth =
        (width - (horizontalPadding * 2) - itemSpacing) / 2;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            controller: _adScroll,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: horizontalPadding),
            child: Row(

              children: List.generate(
                itemCount,
                  (i) => Container(
                  width: itemWidth,
                  height: height * 0.75,
                  margin: EdgeInsets.only(
                    right: i == itemCount - 1 ? 0 : itemSpacing,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://picsum.photos/id/${i + 50}/800/400", // TODO !! 이미지 변경
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildArrowBtn(
            left: AppSpacing.md,
            isLeft: true,
            onTap: () => _scrollByItem(
              _adScroll,
              itemWidth,
              itemSpacing,
              true,
            ),
          ),
          _buildArrowBtn(
            left: width - AppSpacing.md - AppSpacing.lg,
            isLeft: false,
            onTap: () => _scrollByItem(
              _adScroll,
              itemWidth,
              itemSpacing,
              false,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 스타일 공통
  Widget _buildSection(
      double width,
      double height,
      String title,
      bool isHot,
      ScrollController controller,
      ) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;

    final itemCount = dummyItems.length;

    final itemWidth =
        (width - (horizontalPadding * 2) - (itemSpacing * 3)) / 4;

    return SizedBox(
      height: height + AppSpacing.xl,
      child: Stack(
        children: [
          /// 타이틀
          Positioned(
            left: horizontalPadding,
            top: height * 0.1,
            child: Row(
              // TODO NOTE 메인 페이지에만 있어서 textStyle 변수 안 썼습니다!
              children: [
                Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    )
                ),
                if (isHot)
                  Container(
                    margin: const EdgeInsets.only(left: AppSpacing.xs),
                    padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                    color: AppColors.black,
                    child: Text(
                      'HOT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// 리스트
          Positioned(
            top: height * 0.25,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: List.generate(
                  itemCount,
                      (i) => Container(
                    width: itemWidth,
                    margin: EdgeInsets.only(
                      right: i == itemCount - 1 ? 0 : itemSpacing,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                              image: DecorationImage(
                                image: NetworkImage(dummyItems[i]['img']!), // TODO 이미지
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          height: 36,
                          child: Text(
                            dummyItems[i]['title']!, // TODO 타이틀 변경
                            style: AppTextStyles.subTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          dummyItems[i]['price']!, // TODO 가격 변경
                          style: AppTextStyles.subTitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 왼쪽 화살표
          _buildArrowBtn(
            left: AppSpacing.md,
            top: height * 0.46,
            isLeft: true,
            onTap: () => _scrollByItem(
              controller,
              itemWidth,
              itemSpacing,
              true,
            ),
          ),

          /// 오른쪽 화살표
          _buildArrowBtn(
            left: width - AppSpacing.md - AppSpacing.lg,
            top: height * 0.46,
            isLeft: false,
            onTap: () => _scrollByItem(
              controller,
              itemWidth,
              itemSpacing,
              false,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildArrowBtn({
    required double left,
    double? top,
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 18,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            border: Border.all(color: Colors.grey),
          ),
          child: Icon(
            isLeft ? Icons.chevron_left : Icons.chevron_right,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // BOTTOM BAR
  Widget _buildBottomBar(double height) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_filled, color: Color(0xFFA7A6CB)),
          Icon(Icons.search),
          Icon(Icons.map_outlined),
          Icon(Icons.favorite_border),
          Icon(Icons.person_outline),
        ],
      ),
    );
  }
}
