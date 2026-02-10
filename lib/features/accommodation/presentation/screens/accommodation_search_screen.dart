import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
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
  late TextEditingController _locationController;

  String? tempLocation;
  DateTimeRange? tempDateRange;
  int? tempGuestCount;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AccommodationProvider>();

    tempLocation = provider.keyword;
    tempDateRange = provider.dateRange;
    tempGuestCount = provider.guestNumber;

    _locationController = TextEditingController(text: tempLocation ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      appBar: AppBarWidget(title: "숙소 검색"),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          SearchBox(
            width: size.width * 0.9,
            firstRow: LocationInputRow(controller: _locationController),
            dateRange: tempDateRange ?? provider.dateRange,
            guestCount: tempGuestCount ?? provider.guestNumber,
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
    final trimmedLocation = _locationController.text.trim();

    if (trimmedLocation.isEmpty) {
      SnackMessenger.showMessage(
        context,
        "숙소명 또는 지역을 입력해주세요.",
        bottomPadding: AppSpacing.xxxxl,
        type: ToastType.error,
      );
      return;
    }

    final provider = context.read<AccommodationProvider>();

    provider.setSearchDate(
      keywordValue: trimmedLocation,
      dateRangeValue: tempDateRange ?? provider.dateRange,
      guestNumberValue: tempGuestCount ?? provider.guestNumber,
    );

    context.push("/accommodation-result");
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}