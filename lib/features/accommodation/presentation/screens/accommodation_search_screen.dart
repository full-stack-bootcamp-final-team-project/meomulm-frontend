import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_button_field.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/search_box.dart';

class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() =>
      _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  String location = '';
  DateTimeRange? dateRange;
  int guestCount = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarWidget(title: "숙소 검색"),
      body: Column(
        children: [
          const SizedBox(height: 24),

          SearchBox(
            width: size.width * 0.9,
            location: location,
            dateRange: dateRange,
            guestCount: guestCount,
            onLocationChanged: (v) => setState(() => location = v),
            onDateChanged: (v) => setState(() => dateRange = v),
            onGuestChanged: (v) => setState(() => guestCount = v),
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
    debugPrint('지역: $location');
    debugPrint('날짜: $dateRange');
    debugPrint('인원: $guestCount');

    // Navigator.push(...)
  }
}
