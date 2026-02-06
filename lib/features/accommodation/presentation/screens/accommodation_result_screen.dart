import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
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
  List<SearchAccommodationResponseModel> accommodations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAccommodations();
  }

  Future<void> loadAccommodations() async {
    final searchProvider = context.read<AccommodationProvider>();

    // 검색어와 좌표 정보가 모두 없으면 리스트 비움
    if ((searchProvider.keyword?.trim().isEmpty ?? true) && searchProvider.latitude == null) {
      setState(() {
        isLoading = false;
        accommodations = [];
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      // 검색 조건 + 필터 조건 합치기
      final filterProvider = context.read<FilterProvider>();

      final params = {
        ...searchProvider.searchParams,  // 검색 조건
        ...filterProvider.filterParams,   // 필터 조건
      };

      final response = await AccommodationApiService.searchAccommodations(
        params: params,
      );

      setState(() {
        accommodations = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
      setState(() {
        accommodations = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();  // Provider 변화 감지

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchBarWidget(
          keyword: provider.keyword ?? "",
          peopleCount: provider.guestNumber,
          dateText: DatePeopleTextUtil.range(provider.checkIn, provider.checkOut),
        onFilter: () async {
          final result = await context.push(
            '${RoutePaths.accommodationFilter}'
          );

          // 필터 적용했을 때 목록 재조회
          if (result == true) {
            loadAccommodations();
          }
        },
        onBack: () {
          // 각 Provider가 자신의 상태 초기화
          context.read<AccommodationProvider>().resetSearchData();
          context.read<FilterProvider>().resetFilters();
          Navigator.pop(context);
        },
        onClear: () {
          // 각 Provider가 자신의 상태 초기화
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (accommodations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.hotel_outlined,
                size: 64,
                color: Colors.grey[400]
            ),
            const SizedBox(height: 16),
            const Text(
                '조건에 맞는 결과가 없습니다',
                style: TextStyle(fontSize: 16)
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: accommodations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AccommodationCard(accommodation: accommodations[index]),
        );
      },
    );
  }
}