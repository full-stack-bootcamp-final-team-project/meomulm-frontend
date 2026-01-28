import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/search/search_box.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_widgets/location_select_row.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  String region = '';
  DateTimeRange? dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );
  int guestCount = 2;

  Future<void> _openRegionSelector() async {
    final result = await context.push<Map<String, String>>(
      RoutePaths.mapSearchRegion,
    );

    if (result != null && result['detailRegion'] != null) {
      setState(() {
        region = result['detailRegion']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarWidget(title: "지도 검색"),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          SearchBox(
            width: size.width * 0.9,
            firstRow: LocationSelectRow(
              region: region,
              onTap: _openRegionSelector,
            ),
            dateRange: dateRange,
            guestCount: guestCount,
            onDateChanged: (v) => setState(() => dateRange = v),
            onGuestChanged: (v) => setState(() => guestCount = v),
          ),

          const Spacer(),

          BottomActionButton(label: "지도에서 보기", onPressed: _onSearch),
        ],
      ),
    );
  }

  void _onSearch() {
    if (region.isEmpty || dateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지역을 선택해주세요')),
      );
      return;
    }

    context.push(
      RoutePaths.mapSearchResult,
      extra: {
        'region': region,
        'dateRange': dateRange,
        'guestCount': guestCount,
      },
    );
  }
}
