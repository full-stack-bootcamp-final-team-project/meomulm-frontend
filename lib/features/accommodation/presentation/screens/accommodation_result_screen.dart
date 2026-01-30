import 'package:flutter/material.dart';
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
  String tempLocation = '';
  DateTimeRange? tempDateRange;
  int tempGuestCount = 2;
  List<SearchAccommodationResponseModel> accommodations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AccommodationProvider>();
    tempLocation = provider.accommodationName ?? '';
    tempDateRange = provider.dateRange;
    tempGuestCount = provider.guestCount;
    // 검색어가 비어있으면 로딩하지 않음
    if (tempLocation.trim().isEmpty) {
      setState(() {
        isLoading = false;
        accommodations = [];
      });
    } else {
      loadAccommodations();
    }
  }

  Future<void> loadAccommodations() async {
    // 검색어가 비어있으면 조기 반환
    if (tempLocation.trim().isEmpty) {
      setState(() {
        isLoading = false;
        accommodations = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AccommodationApiService.getAccommodationByKeyword(
        keyword: tempLocation.trim(),
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
    final provider = context.read<AccommodationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchBarWidget(
        keyword: provider.accommodationName,
        peopleCount: provider.guestCount,
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
          if (result != null) {
            // result는 provider.toQuery()에서 반환한 Map<String, dynamic> 형태입니다.
            debugPrint('적용된 필터: $result');
            // 여기서 필터된 데이터를 다시 로드하는 함수를 호출하세요.
            // 예: _loadFilteredAccommodations(result);
          }
        },
        onBack: () => Navigator.pop(context),
        onClear: () {
          Navigator.pop(context);
          provider.clearAccommodationName();
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            // child: isLoading
            //   ?
            //     Center(child: CircularProgressIndicator())
            //   :
            //     accommodations.isEmpty
            //     ?
            //       Center(child: Text("사용자가 없습니다."))   // 로딩상태는 아니지만 로딩 결과 존재하는 유저가 없을 때
            //     :
            //       _buildBodyContent(),
              child: _buildBodyContent()
          ),
        ],
      ),
    );
  }


  Widget _buildBodyContent() {
    // 로딩 중
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 검색어가 비어있을 때
    if (tempLocation.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '검색어를 입력해주세요',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // 검색 결과가 없을 때
    if (accommodations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 검색어로 시도해보세요',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // 정상적인 결과 목록
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