import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/hotel_card.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/result_topBar.dart';
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
    final provider = context.read<AccommodationProvider>();

    // 검색어와 좌표 정보가 모두 없으면 리스트 비움
    if ((provider.keyword?.trim().isEmpty ?? true) && provider.latitude == null) {
      setState(() {
        isLoading = false;
        accommodations = [];
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      // 통합된 searchParams를 서버 전달 (키워드 + 필터)
      final response = await AccommodationApiService.searchAccommodations(
        params: provider.searchParams,
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
        dateText:
        '${provider.checkIn.year}.${provider.checkIn.month}.${provider.checkIn.day} '
            '- ${provider.checkOut.year}.${provider.checkOut.month}.${provider.checkOut.day}',
        onFilter: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccommodationFilterScreen(),
            ),
          );

          // Navigator.pop(context.go) 기존 창 복귀
          // -> initState 동작 X
          // -> 필터 적용했을 때 목록 재조회
          if (result == true) {
            loadAccommodations();
          }
        },
        onBack: () {
          provider.resetAllData();
          provider.resetFilters();
          Navigator.pop(context);
        },
        onClear: () {
          provider.resetAllData();
          provider.resetFilters();
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
    if (isLoading)
      return const Center(child: CircularProgressIndicator());

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
          child: HotelCard(accommodation: accommodations[index]),
        );
      },
    );
  }
}