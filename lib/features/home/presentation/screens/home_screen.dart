import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/bottom_nav_bar_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_ad_section_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_section_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/home_header_widget.dart';

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
    {"title": "박세원", "url": "https://github.com/svv0003", "imageUrl": "assets/images/ad/ad_01.png"},
    {"title": "박형빈", "url": "https://github.com/PHB-1994", "imageUrl": "assets/images/ad/ad_02.png"},
    {"title": "유기태", "url": "https://github.com/tiradovi", "imageUrl": "assets/images/ad/ad_01.png"},
    {"title": "오유성", "url": "https://github.com/Emma10003", "imageUrl": "assets/images/ad/ad_02.png"},
    {"title": "조연희", "url": "https://github.com/yeonhee-cho", "imageUrl": "assets/images/ad/ad_01.png"},
    {"title": "현윤선", "url": "https://github.com/yunseonhyun", "imageUrl": "assets/images/ad/ad_02.png"},
  ];

  // 숙소 가데이터
  static final List<Map<String, String>> dummyItems = List.generate(
      12,
          (index) => {
        "title": "라발스 호텔 부산 ${index + 1}",
        "price": "86,660원 ~",
        "img": "https://picsum.photos/id/${index + 10}/400/600",
      });

  // 스크롤
  void _scrollByItem(ScrollController controller, double itemWidth, double spacing, bool isLeft) {
    final step = itemWidth + spacing;
    final targetOffset = controller.offset + (isLeft ? -step : step);
    final clampedOffset = targetOffset.clamp(0.0, controller.position.maxScrollExtent);
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
          final adHeight = width * 0.28;
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
                      HomeHeaderWidget(onLogoTap: _refreshHome),
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