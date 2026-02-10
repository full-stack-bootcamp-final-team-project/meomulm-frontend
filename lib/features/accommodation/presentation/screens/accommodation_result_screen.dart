import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
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
  State<AccommodationResultScreen> createState() => _AccommodationResultScreen();
}

class _AccommodationResultScreen extends State<AccommodationResultScreen> {
  final ScrollController _scrollController = ScrollController();    // (무한) 스크롤 컨트롤러
  List<AccommodationResponseModel> accommodations = [];
  bool isLoading = true;
  bool isFetchingMore = false;          // 추가 데이터 로딩 중 하단 인디케이터
  bool hasMore = true;                  // 서버로부터 더 가져올 데이터가 있는지 여부
  final int searchLimit = 20;                 // 한 번에 가져오는 숙소 조회 결과 개수



  @override
  void initState() {
    super.initState();

    // 초기 숙소 조회
    loadAccommodations(isFirstLoad: true);

    // 스크롤 감지 리스너
    _scrollController.addListener(() {
      // 하단 200px 감지 시 미리 호출
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // 로딩 상태 아니면서, 더 가져올 데이터가 있을 때만 실행
        if (!isFetchingMore && hasMore && !isLoading) {
          loadAccommodations(isFirstLoad: false);
        }
      }
    });
  }

  // Future<void> loadAccommodations() async {
  //   final searchProvider = context.read<AccommodationProvider>();
  //
  //   if ((searchProvider.keyword?.trim().isEmpty ?? true)
  //       && searchProvider.latitude == null) {
  //     setState(() {
  //       isLoading = false;
  //       accommodations = [];
  //     });
  //     return;
  //   }
  //
  //   setState(() => isLoading = true);
  //
  //   try {
  //     final filterProvider = context.read<FilterProvider>();
  //
  //     final params = {
  //       'lastIndex': accommodations.length,
  //       'limit': 20,
  //       ...searchProvider.searchParams,   // 검색 조건
  //       ...filterProvider.filterParams,   // 필터 조건
  //     };
  //
  //     final response = await AccommodationApiService.searchAccommodations(
  //       params: params,
  //     );
  //
  //     setState(() {
  //       accommodations = response;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     debugPrint('데이터 로드 실패: $e');
  //     setState(() {
  //       accommodations = [];
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> loadAccommodations({required bool isFirstLoad}) async {
    final searchProvider = context.read<AccommodationProvider>();
    final filterProvider = context.read<FilterProvider>();

    // 중복 호출 차단
    if (!isFirstLoad && (isFetchingMore || !hasMore)) return;

    // 검색 조건이 아예 없는 경우
    if ((searchProvider.keyword?.trim().isEmpty ?? true) &&
        searchProvider.latitude == null) {
      setState(() {
        isLoading = false;
        accommodations = [];
      });
      return;
    }

    // 필터 변경 등 첫 로드 시 리스트 비우기
    if (isFirstLoad) {
      setState(() {
        isLoading = true;
        accommodations = [];
        hasMore = true;
      });
    } else {
      if (isFetchingMore || !hasMore) return;
      setState(() => isFetchingMore = true);
    }

    try {
      final params = {
        'lastIndex': accommodations.length,
        'searchLimit': searchLimit,
        ...searchProvider.searchParams,
        ...filterProvider.filterParams,
      };

      final response = await AccommodationApiService.searchAccommodations(
        params: params,
      );

      setState(() {
        if (response.isEmpty) {
          hasMore = false;
        } else {
          // 기존 리스트 뒤에 새 데이터를 합친다.
          accommodations.addAll(response);
          // 가져온 개수가 limit보다 적으면 남은 조회 결과 없다고 간주한다.
          if (response.length < searchLimit) hasMore = false;
        }
        isLoading = false;
        isFetchingMore = false;
      });
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: SearchBarWidget(
        keyword: provider.keyword ?? "",
        peopleCount: provider.guestNumber,
        dateText: DatePeopleTextUtil.range(provider.checkIn, provider.checkOut),
        onFilter: () async {
          final result = await context.push('${RoutePaths.accommodationFilter}');
          if (result == true) {
            loadAccommodations(isFirstLoad: true);
          }
        },
        onBack: _resetAndPop,
        onClear: _resetAndPop,
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  void _resetAndPop() {
    context.read<AccommodationProvider>().resetSearchData();
    context.read<FilterProvider>().resetFilters();
    Navigator.pop(context);
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (accommodations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                AppIcons.hotelBed,
                size: AppIcons.sizeXxxxxl,
                color: AppColors.gray2
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
                '조건에 맞는 결과가 없습니다',
                style: TextStyle(fontSize: 16)
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      // 스크롤 감지를 위해 컨트롤러 연결
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm
      ),
      // 데이터가 더 있다면 하단 로딩바 자리 고려
      itemCount: accommodations.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < accommodations.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AccommodationCard(accommodation: accommodations[index]),
          );
        } else {
          // 리스트 맨 아래 도달했을 때 로딩 인디케이터 표시
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}