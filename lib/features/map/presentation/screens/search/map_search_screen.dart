import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/search/search_box.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_widgets/location_select_row.dart';
import 'package:provider/provider.dart';

/// 지도 검색 조건을 설정하는 스크린
class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  String? tempRegion;
  DateTimeRange? tempDateRange;
  int? tempGuestCount;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AccommodationProvider>();

    tempRegion = null;
    tempDateRange = provider.dateRange;
    tempGuestCount = provider.guestNumber;
  }

  Future<void> _openRegionSelector() async {
    final result = await context.push<Map<String, String>>(
      RoutePaths.mapSearchRegion,
    );

    if (result != null && result['detailRegion'] != null) {
      setState(() {
        tempRegion = result['detailRegion']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      appBar: AppBarWidget(title: "지도 검색"),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          SearchBox(
            width: size.width * 0.9,
            firstRow: LocationSelectRow(
              region: tempRegion ?? '',
              onTap: _openRegionSelector,
            ),
            dateRange: tempDateRange ?? provider.dateRange,
            guestCount: tempGuestCount ?? provider.guestNumber,
            onDateChanged: (v) => setState(() => tempDateRange = v),
            onGuestChanged: (v) => setState(() => tempGuestCount = v),
          ),

          const Spacer(),

          BottomActionButton(label: "지도에서 보기", onPressed: _onSearch),
        ],
      ),
    );
  }

  void _onSearch() {
    if (tempRegion?.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지역을 선택해주세요')),
      );
      return;
    }

    final provider = context.read<AccommodationProvider>();

    provider.setSearchDate(
      dateRangeValue: tempDateRange ?? provider.dateRange,
      guestNumberValue: tempGuestCount ?? provider.guestNumber,
    );

    context.push(
      RoutePaths.mapSearchResult,
      extra: tempRegion,
    );
  }
}