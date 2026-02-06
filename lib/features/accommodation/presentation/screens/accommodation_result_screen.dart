import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/accommodation_card.dart';
import 'package:provider/provider.dart';

class AccommodationResultScreen extends StatefulWidget {
  const AccommodationResultScreen({super.key});

  @override
  State<AccommodationResultScreen> createState() => _AccommodationResultScreenState();
}

class _AccommodationResultScreenState extends State<AccommodationResultScreen> {
  List<AccommodationResponseModel> accommodations = [];
  int currentPage = 1;
  final int pageSize = 12; // 한 페이지당 10~15개 추천 (체감속도 좋음)
  bool hasMore = true;
  bool isInitialLoading = true;
  bool isLoadingMore = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadAccommodations(initial: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 400 &&
        !isLoadingMore &&
        hasMore &&
        !_scrollController.position.outOfRange) {
      _loadAccommodations();
    }
  }

  Future<void> _loadAccommodations({bool initial = false}) async {
    if (initial) {
      setState(() {
        isInitialLoading = true;
        accommodations.clear();
        currentPage = 1;
        hasMore = true;
      });
    } else {
      if (isLoadingMore || !hasMore) return;
      setState(() => isLoadingMore = true);
    }

    try {
      final searchProvider = context.read<AccommodationProvider>();
      final filterProvider = context.read<FilterProvider>();

      // 검색 조건 + 필터 + 페이지네이션 파라미터
      final params = {
        ...searchProvider.searchParams,
        ...filterProvider.filterParams,
        'page': currentPage.toString(),
        'size': pageSize.toString(),
      };

      final newItems = await AccommodationApiService.searchAccommodations(params: params);

      setState(() {
        accommodations.addAll(newItems);
        currentPage++;
        hasMore = newItems.length >= pageSize; // 덜 받았으면 마지막 페이지
        isInitialLoading = false;
        isLoadingMore = false;
      });
    } catch (e) {
      debugPrint('숙소 로드 실패: $e');
      setState(() {
        isInitialLoading = false;
        isLoadingMore = false;
        hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchBarWidget(
        keyword: provider.keyword ?? "",
        peopleCount: provider.guestNumber,
        dateText: DatePeopleTextUtil.range(provider.checkIn, provider.checkOut),
        onFilter: () async {
          final result = await context.push('${RoutePaths.accommodationFilter}');
          if (result == true) {
            _loadAccommodations(initial: true); // 필터 적용 → 초기화 후 재조회
          }
        },
        onBack: () {
          context.read<AccommodationProvider>().resetSearchData();
          context.read<FilterProvider>().resetFilters();
          Navigator.pop(context);
        },
        onClear: () {
          context.read<AccommodationProvider>().resetSearchData();
          context.read<FilterProvider>().resetFilters();
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (accommodations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('조건에 맞는 결과가 없습니다', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadAccommodations(initial: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: accommodations.length + (hasMore || isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == accommodations.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AccommodationCard(accommodation: accommodations[index]),
          );
        },
      ),
    );
  }
}