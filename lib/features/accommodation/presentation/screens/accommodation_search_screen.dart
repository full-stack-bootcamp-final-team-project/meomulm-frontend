import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/bottom_button_box.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/custom_appBar.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/search_box.dart';


class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() => _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  final GlobalKey<SearchBoxState> _searchBoxKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(appBarTitle: "숙소 검색"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // SearchBox는 width * 0.9 → 좌우 여백 생김 (네가 원하는 대로)
          SearchBox(
            key: _searchBoxKey,
            width: size.width * 0.9,
          ),

          const Spacer(),

          // BottomButtonBox는 패딩 없이 그대로 꽂음 (full width 가정)
          BottomButtonBox(
            buttonName: "검색하기",
            onPressed: () {
              final state = _searchBoxKey.currentState;
              if (state == null) return;

              // final location = state.locationText.trim();
              // final range = state.selectedRange;
              // final guests = state.guestCount;
              //
              // final msg = '검색 조건\n'
              //     '지역/숙소: ${location.isNotEmpty ? location : "미입력"}\n'
              //     '날짜: ${range != null ? "${range.start.year}.${range.start.month}.${range.start.day} ~ ${range.end.year}.${range.end.month}.${range.end.day}" : "미선택"}\n'
              //     '인원: $guests명';
              //
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
              // );

              // 여기에 실제 검색 로직 (Navigator.push 등) 넣으면 됨
            },
          ),
        ],
      ),
    );
  }
}

