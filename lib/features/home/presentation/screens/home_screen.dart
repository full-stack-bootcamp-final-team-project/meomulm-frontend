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

  //  세로 스크롤 컨트롤러
  final ScrollController _verticalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentGradient = AppGradients.byTime();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateGradientIfNeeded(),
    );
  }

  // 새로 고침(홈 -> 홈 가는 버튼 클릭 시)
  // 홈의 전체 스크롤 처음으로 돌리기(화면 최상단 이동 포함)
  void _refreshHome() {
    _verticalScroll.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    _adScroll.jumpTo(0);
    _recentScroll.jumpTo(0);
    _seoulScroll.jumpTo(0);
    _jejuScroll.jumpTo(0);
    _busanScroll.jumpTo(0);

    setState(() {
      _currentGradient = AppGradients.byTime();
    });
  }

  // 시간대별 메인 컬러 변경
  void _updateGradientIfNeeded() {
    final newGradient = AppGradients.byTime();
    if (newGradient != _currentGradient) {
      setState(() => _currentGradient = newGradient);
    }
  }

  // 스크롤 컨트롤러
  static final ScrollController _adScroll = ScrollController();
  static final ScrollController _recentScroll = ScrollController();
  static final ScrollController _seoulScroll = ScrollController();
  static final ScrollController _jejuScroll = ScrollController();
  static final ScrollController _busanScroll = ScrollController();

  // 광고영역 데이터 - 팀원 정보 TODO 이미지 변경 필요
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

  // 숙소 가데이터
  static final List<Map<String, String>> dummyItems = List.generate(
    12,
    (index) => {
      "title": "라발스 호텔 부산 ${index + 1}",
      "price": "86,660원 ~",
      "img": "https://picsum.photos/id/${index + 10}/400/600",
    },
  );

  // 스크롤
  void _scrollByItem(
    ScrollController controller,
    double itemWidth,
    double spacing,
    bool isLeft,
  ) {
    final step = itemWidth + spacing;
    final targetOffset = controller.offset + (isLeft ? -step : step);
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

  // 팀원 깃허브 이동을 위한 기능
  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // 뷰
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final adHeight = width * 0.25;
          final sectionHeight = width * 0.5;

          return AnimatedContainer(
            width: double.infinity,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(gradient: _currentGradient),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      HeaderWidget(onLogoTap: _refreshHome),
                      Positioned.fill(
                        top: 120,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppBorderRadius.xxl),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: _verticalScroll,
                            child: Column(
                              children: [
                                AdSectionWidget(
                                  height: adHeight,
                                  width: width,
                                  items: ADItems,
                                  controller: _adScroll,
                                  onItemTap: _openExternalUrl,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "최근 본 숙소",
                                  isHot: false,
                                  items: dummyItems,
                                  controller: _recentScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "서울",
                                  isHot: true,
                                  items: dummyItems,
                                  controller: _seoulScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "제주",
                                  isHot: true,
                                  items: dummyItems,
                                  controller: _jejuScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "부산",
                                  isHot: true,
                                  items: dummyItems,
                                  controller: _busanScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                const SizedBox(height: AppSpacing.sm),
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
      // 탭
      bottomNavigationBar: SafeArea(
        child: BottomNavBarWidget(onHomeTap: _refreshHome),
      ),
    );
  }
}

/// ======================== 위젯 분리 ========================
/// ======================== HeaderWidget ========================
/// 헤더 영역(로고 + 알림)
class HeaderWidget extends StatelessWidget {
  final VoidCallback onLogoTap;

  const HeaderWidget({super.key, required this.onLogoTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xxxl + AppSpacing.md,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onLogoTap,
            child: Image.asset(
              'assets/images/main_logo.png',
              width: 60,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                '머묾',
                style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
              ),
            ),
          ),
          Icon(
            AppIcons.notifications,
            color: AppColors.white,
            size: AppIcons.sizeXxl,
          ),
        ],
      ),
    );
  }
}

/// ======================== AdSectionWidget ========================
/// 광고 영역(팀원 정보)
class AdSectionWidget extends StatelessWidget {
  final double height, width;
  final List<Map<String, String>> items;
  final ScrollController controller;
  final void Function(String url) onItemTap;
  final void Function(ScrollController, double, double, bool) scrollByItem;

  const AdSectionWidget({
    super.key,
    required this.height,
    required this.width,
    required this.items,
    required this.controller,
    required this.onItemTap,
    required this.scrollByItem,
  });

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemWidth = (width - horizontalPadding * 2 - itemSpacing) / 2;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: horizontalPadding),
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return GestureDetector(
                  onTap: () => onItemTap(item["url"]!),
                  child: Container(
                    width: itemWidth,
                    height: itemWidth * 0.43,
                    margin: EdgeInsets.only(
                      right: i == items.length - 1 ? 0 : itemSpacing,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                      image: DecorationImage(
                        image: AssetImage(item["imageUrl"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          ArrowButtonWidget(
            left: AppSpacing.md,
            isLeft: true,
            onTap: () => scrollByItem(controller, itemWidth, itemSpacing, true),
          ),
          ArrowButtonWidget(
            left: width - AppSpacing.md - AppSpacing.lg,
            isLeft: false,
            onTap: () =>
                scrollByItem(controller, itemWidth, itemSpacing, false),
          ),
        ],
      ),
    );
  }
}

/// ======================== HomeSectionWidget ========================
/// 이 외 세션 영역(숙소 리스트)
class HomeSectionWidget extends StatelessWidget {
  final double width, height;
  final String title;
  final bool isHot;
  final List<Map<String, String>> items;
  final ScrollController controller;
  final void Function(ScrollController, double, double, bool) scrollByItem;

  const HomeSectionWidget({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.isHot,
    required this.items,
    required this.controller,
    required this.scrollByItem,
  });

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemWidth = (width - horizontalPadding * 2 - itemSpacing * 3) / 4;

    return SizedBox(
      height: height + AppSpacing.xxxl,
      child: Stack(
        children: [
          // 세션 타이틀 영역
          Positioned(
            left: horizontalPadding,
            top: height * 0.1,
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                if (isHot)
                  Container(
                    margin: const EdgeInsets.only(left: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
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
          // 세션 내용 영역
          Positioned(
            top: height * 0.25,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Row(
                children: List.generate(
                  items.length,
                  (i) => HomeItemCard(
                    item: items[i],
                    width: itemWidth,
                    isLast: i == items.length - 1,
                  ),
                ),
              ),
            ),
          ),
          // 세션 화살표
          ArrowButtonWidget(
            left: AppSpacing.md,
            top: height * 0.46,
            isLeft: true,
            onTap: () => scrollByItem(controller, itemWidth, itemSpacing, true),
          ),
          ArrowButtonWidget(
            left: width - AppSpacing.md - AppSpacing.lg,
            top: height * 0.46,
            isLeft: false,
            onTap: () =>
                scrollByItem(controller, itemWidth, itemSpacing, false),
          ),
        ],
      ),
    );
  }
}

/// ======================== HomeItemCard ========================
/// 숙소 아이템
class HomeItemCard extends StatelessWidget {
  final Map<String, String> item;
  final double width;
  final bool isLast;

  const HomeItemCard({
    super.key,
    required this.item,
    required this.width,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: isLast ? 0 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                image: DecorationImage(
                  image: NetworkImage(item['img']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item['title']!,
            style: AppTextStyles.subTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item['price']!,
            style: AppTextStyles.subTitle.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// ======================== ArrowButtonWidget ========================
/// 리스트 양쪽 화살표 영역
class ArrowButtonWidget extends StatelessWidget {
  final double left;
  final double? top;
  final bool isLeft;
  final VoidCallback onTap;

  const ArrowButtonWidget({
    super.key,
    required this.left,
    this.top,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// ======================== BottomNavBarWidget ========================
/// 탭 영역(홈에서만 노출)
class BottomNavBarWidget extends StatelessWidget {
  final VoidCallback onHomeTap;

  const BottomNavBarWidget({super.key, required this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppShadows.bottomNav,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(
            context,
            AppIcons.home,
            RoutePaths.home,
            color: AppColors.main,
          ),
          _navIcon(context, AppIcons.search, RoutePaths.accommodationSearch),
          _navIcon(context, AppIcons.map, RoutePaths.map),
          _navIcon(
            context,
            AppIcons.favorite,
            '${RoutePaths.myPage}${RoutePaths.favorite}',
          ),
          _navIcon(context, AppIcons.person, RoutePaths.myPage),
        ],
      ),
    );
  }

  Widget _navIcon(
    BuildContext context,
    IconData icon,
    String page, {
    Color color = AppColors.black,
  }) {
    return GestureDetector(
      onTap: () {
        if (page == RoutePaths.home) {
          onHomeTap();
        } else {
          context.push(page);
        }
      },
      child: Icon(icon, size: AppIcons.sizeXl, color: color),
    );
  }
}
