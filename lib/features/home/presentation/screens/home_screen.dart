import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/home/presentation/providers/home_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/bottom_nav_bar_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_ad_section_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_header_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_section_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  late LinearGradient _currentGradient;
  late final Timer _timer;

  //  세로 스크롤 컨트롤러
  final ScrollController _verticalScroll = ScrollController();

  // 스크롤 컨트롤러
  final ScrollController _adScroll = ScrollController();
  final ScrollController _recentScroll = ScrollController();
  final ScrollController _seoulScroll = ScrollController();
  final ScrollController _jejuScroll = ScrollController();
  final ScrollController _busanScroll = ScrollController();

  @override
  void dispose() {
    _verticalScroll.dispose();
    _adScroll.dispose();
    _recentScroll.dispose();
    _seoulScroll.dispose();
    _jejuScroll.dispose();
    _busanScroll.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _currentGradient = AppGradients.byTime();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => _updateGradientIfNeeded(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final auth = context.read<AuthProvider>();

        context.read<HomeProvider>().loadHome(isLoggedIn: auth.isLoggedIn,);
      });
    });
  }

  // 새로 고침(홈 -> 홈 가는 버튼 클릭 시)
  // 홈의 전체 스크롤 처음으로 돌리기(화면 최상단 이동 포함)
  void _refreshHome() {
    _verticalScroll.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );

    if (_adScroll.hasClients) _adScroll.jumpTo(0);
    if (_recentScroll.hasClients) _recentScroll.jumpTo(0);
    if (_seoulScroll.hasClients) _seoulScroll.jumpTo(0);
    if (_jejuScroll.hasClients) _jejuScroll.jumpTo(0);
    if (_busanScroll.hasClients) _busanScroll.jumpTo(0);

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

  // 광고영역 데이터 - 팀원 정보 TODO 이미지 변경 필요
  static final List<Map<String, String>> ADItems = [
    {"title": "박세원", "url": "https://github.com/svv0003", "imageUrl": "assets/images/ad/ad_svv0003.png"},
    {"title": "박형빈", "url": "https://github.com/PHB-1994", "imageUrl": "assets/images/ad/ad_PHB-1994.png"},
    {"title": "유기태", "url": "https://github.com/tiradovi", "imageUrl": "assets/images/ad/ad_tiradovi.png"},
    {"title": "오유성", "url": "https://github.com/Emma10003", "imageUrl": "assets/images/ad/ad_Emma10003.png"},
    {"title": "조연희", "url": "https://github.com/yeonhee-cho", "imageUrl": "assets/images/ad/ad_yeonhee-cho.png"},
    {"title": "현윤선", "url": "https://github.com/yunseonhyun", "imageUrl": "assets/images/ad/ad_yunseonhyun.png"},
  ];

  // 뷰
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    if (homeProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final adHeight = width * 0.28;
          final sectionHeight = width * 0.6;

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
                                // 최근 본 숙소
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "최근 본 숙소",
                                  isHot: false,
                                  items: homeProvider.recentList,
                                  controller: _recentScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "서울",
                                  isHot: true,
                                  items: homeProvider.seoulList,
                                  controller: _seoulScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "제주",
                                  isHot: true,
                                  items: homeProvider.jejuList,
                                  controller: _jejuScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                HomeSectionWidget(
                                  width: width,
                                  height: sectionHeight,
                                  title: "부산",
                                  isHot: true,
                                  items: homeProvider.busanList,
                                  controller: _busanScroll,
                                  scrollByItem: _scrollByItem,
                                ),
                                const SizedBox(height: AppSpacing.sm),

                                const SizedBox(height: AppSpacing.xl),
                                const SizedBox(height: AppSpacing.xxl),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.smart_toy, color: AppColors.white),
        onPressed: () => context.push('${RoutePaths.chat}')
      ),
      // 탭
      bottomNavigationBar: SafeArea(
        child: BottomNavBarWidget(onHomeTap: _refreshHome),
      ),
    );
  }
}