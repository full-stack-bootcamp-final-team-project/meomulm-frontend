import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LinearGradient _currentGradient;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentGradient = AppGradients.byTime();

    _timer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => _updateGradientIfNeeded(),
    );
  }

  void _updateGradientIfNeeded() {
    final newGradient = AppGradients.byTime();
    if (newGradient != _currentGradient) {
      setState(() => _currentGradient = newGradient);
    }
  }

  static final ScrollController _adScroll = ScrollController();
  static final ScrollController _recentScroll = ScrollController();
  static final ScrollController _seoulScroll = ScrollController();
  static final ScrollController _jejuScroll = ScrollController();
  static final ScrollController _busanScroll = ScrollController();

  // 가데이터 AD
  static final List<Map<String, String>> ADItems = [
    {
      "title": "박세원",
      "url": "https://github.com/svv0003",
      "imageUrl": "assets/images/ad/ad_01.png",
    },
    {
      "title": "박형빈",
      "url": "https://github.com/PHB-1994",
      "imageUrl": "assets/images/ad/ad_02.png",
    },
    {
      "title": "유기태",
      "url": "https://github.com/tiradovi",
      "imageUrl": "assets/images/ad/ad_01.png",
    },
    {
      "title": "오유성",
      "url": "https://github.com/Emma10003",
      "imageUrl": "assets/images/ad/ad_02.png",
    },
    {
      "title": "조연희",
      "url": "https://github.com/yeonhee-cho",
      "imageUrl": "assets/images/ad/ad_01.png",
    },
    {
      "title": "현윤선",
      "url": "https://github.com/yunseonhyun",
      "imageUrl": "assets/images/ad/ad_02.png",
    },
  ];

  // 가데이터 숙소
  static final List<Map<String, String>> dummyItems = List.generate(
    12, (index) =>
    {
      "title": "라발스 호텔 부산 ${index + 1}",
      "price": "86,660원 ~",
      "img": "https://picsum.photos/id/${index + 10}/400/600",
    }
  );

  void _scrollByItem(ScrollController controller,
      double itemWidth,
      double spacing,
      bool isLeft,) {
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
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final bottomBarHeight = screenHeight * 0.09;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final headerHeight = height * 0.16;
          final adHeight = width * 0.25;
          final sectionHeight = width * 0.5;

          return AnimatedContainer(
            width: double.infinity,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: _currentGradient,
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(bottomBarHeight, context),
    );
  }

  /// ================== 분리할 내용
  // HEADER
  Widget _buildHeader() {
    return Positioned(
      top: AppSpacing.xxxl + AppSpacing.md,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 로고
          GestureDetector(
            onTap: () => context.push(RoutePaths.home), // 새로고침의 느낌으로 넣어두었습니다!
            child:
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

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // AD SECTION
  Widget _buildAdSection(double height, double width) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemCount = ADItems.length;

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
                  (i) {
                    final item = ADItems[i];

                    return GestureDetector(
                      onTap: () => _openExternalUrl(item["url"]!),
                      child: Semantics(
                        label: item["title"], // 이미지 alt
                        child: Container(
                          width: itemWidth,
                          height: itemWidth * 0.43,
                          margin: EdgeInsets.only(
                            right: i == itemCount - 1 ? 0 : itemSpacing,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppBorderRadius.xs),
                            image: DecorationImage(
                              image: AssetImage(item["imageUrl"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
          _buildArrowBtn(
            left: AppSpacing.md,
            isLeft: true,
            onTap: () =>
              _scrollByItem(
                _adScroll,
                itemWidth,
                itemSpacing,
                true,
              ),
          ),
          _buildArrowBtn(
            left: width - AppSpacing.md - AppSpacing.lg,
            isLeft: false,
            onTap: () =>
              _scrollByItem(
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
  Widget _buildSection(double width,
      double height,
      String title,
      bool isHot,
      ScrollController controller,) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;

    final itemCount = dummyItems.length;

    final itemWidth =
        (width - (horizontalPadding * 2) - (itemSpacing * 3)) / 4;

    return SizedBox(
      height: height + AppSpacing.xxxl,
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
                    const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
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
                      (i) =>
                      Container(
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
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.xs),
                                  image: DecorationImage(
                                    image: NetworkImage(dummyItems[i]['img']!),
                                    // TODO 이미지
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        dummyItems[i]['title']!,
                                        style: AppTextStyles.subTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    dummyItems[i]['price']!,
                                    style: AppTextStyles.subTitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
            onTap: () =>
                _scrollByItem(
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
            onTap: () =>
                _scrollByItem(
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

  // SECTION ARROW BTN
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
          width: AppSpacing.lg + AppSpacing.xxs,
          height: AppSpacing.xl + AppSpacing.xxs,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            border: Border.all(color: AppColors.gray4),
          ),
          child: Icon(
            isLeft ? AppIcons.arrowLeft : AppIcons.arrowRight,
            size: AppIcons.sizeSm,
            color: AppColors.gray1,
          ),
        ),
      ),
    );
  }

  // BOTTOM BAR
  Widget _buildBottomBar(double height, BuildContext context) {
    return Container(
      height: height / 1.3,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppShadows.bottomNav,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(context, AppIcons.home, RoutePaths.home, color: AppColors.main),
          _navIcon(context, AppIcons.search, RoutePaths.searchAccommodation),
          _navIcon(context, AppIcons.map, RoutePaths.map),
          _navIcon(context, AppIcons.favorite, '${RoutePaths.myPage}${RoutePaths.favorite}'),
          _navIcon(context, AppIcons.person, RoutePaths.myPage),
        ],
      ),
    );
  }

  // BOTTOM BAR ICON
  Widget _navIcon(
      BuildContext context,
      IconData icon,
      String page,
      {Color color = AppColors.black}
  ) {
    return GestureDetector(
      onTap: () => context.push(page),
      child: Icon(
        icon,
        size: AppIcons.sizeXl,
        color: color, // 홈만 나오는 탭이므로 홈 부분만 색 고정
      ),
    );
  }
}
