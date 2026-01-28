import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/search/search_box.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/location_input_row.dart';
import 'package:provider/provider.dart';

class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() =>
      _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  String tempLocation = '';
  DateTimeRange? tempDateRange;
  int tempGuestCount = 2;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: tempLocation);
    _locationController.addListener(_onLocationTextChanged);
    final provider = context.read<AccommodationProvider>();
    tempLocation = provider.accommodationName ?? '';
    tempDateRange = provider.dateRange;
    tempGuestCount = provider.guestCount ?? 2;
  }

  void _onLocationTextChanged() {
    setState(() {
      tempLocation = _locationController.text;
    });
  }

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
            firstRow: LocationInputRow(controller: _locationController),
            dateRange: tempDateRange,
            guestCount: tempGuestCount,
            onDateChanged: (v) => setState(() => tempDateRange = v),
            onGuestChanged: (v) => setState(() => tempGuestCount = v),
          ),

          const Spacer(),

          BottomActionButton(
            label: "검색하기",
            onPressed: _onSearch,
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    final provider = context.read<AccommodationProvider>();
    provider.setAccommodationSearch(
      accommodationName: tempLocation,
      dateRange: tempDateRange,
      guestCount: tempGuestCount,
    );

    debugPrint('지역: $tempLocation');
    debugPrint('날짜: $tempDateRange');
    debugPrint('인원: $tempGuestCount');

    context.push("/accommodation-result");


  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationTextChanged);
    _locationController.dispose();
    super.dispose();
  }
}