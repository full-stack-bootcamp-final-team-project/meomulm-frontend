import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_button_field.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/search_box.dart';
import 'package:provider/provider.dart';

class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() =>
      _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  String tempAccommodationName = '';
  DateTimeRange? tempDateRange;
  int tempGuestCount = 2;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AccommodationProvider>();
    tempAccommodationName = provider.accommodationName ?? '';
    tempDateRange = provider.dateRange;
    tempGuestCount = provider.guestCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "숙소 검색"),
      body: Column(
        children: [
          const SizedBox(height: 30),

          SearchBox(
            location: tempAccommodationName,
            dateRange: tempDateRange,
            guestCount: tempGuestCount,
            onChangedLocation: (v) => setState(() => tempAccommodationName = v),
            onChangedDateRange: (v) => setState(() => tempDateRange = v),
            onChangedGuestCount: (v) => setState(() => tempGuestCount = v),
          ),

          const Spacer(),

          BottomButtonField(
            buttonName: "검색하기",
            onPressed: _onSearch,
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    final provider = context.read<AccommodationProvider>();
    provider.setAccommodationSearch(
      accommodationName: tempAccommodationName,
      dateRange: tempDateRange,
      guestCount: tempGuestCount,
    );

    // debug print
    debugPrint('숙소명, 지역: ${provider.accommodationName}');
    debugPrint('날짜: ${provider.dateRange}');
    debugPrint('인원: ${provider.guestCount}');

    context.push("/accommodation-result");
  }
}
