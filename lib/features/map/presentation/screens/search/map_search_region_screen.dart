import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_region_widgets/region_detail_grid.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_region_widgets/region_list_panel.dart';

/// 지도 검색 지역 선택 스크린
class MapSearchRegionScreen extends StatefulWidget {
  const MapSearchRegionScreen({super.key});

  @override
  State<MapSearchRegionScreen> createState() => _MapSearchRegionScreenState();
}

class _MapSearchRegionScreenState extends State<MapSearchRegionScreen> {
  int selectedRegionIndex = 0;

  int _calculateCrossAxisCount(double width) {
    if (width > AppBreakpoints.tablet) return 4;
    if (width > AppBreakpoints.mobile) return 3;
    return 2;
  }

  void _onRegionSelected(String selectedRegion, String detailRegion) {
    context.pop({
      'region': selectedRegion,
      'detailRegion': detailRegion,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final regions = RegionConstants.regions;
    final selectedRegion = regions[selectedRegionIndex];
    final detailList = RegionConstants.regionDetails[selectedRegion]!;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return Scaffold(
      appBar: const AppBarWidget(
        title: TitleLabels.selectRegion,
      ),
      body: Row(
        children: [
          RegionListPanel(
            regions: regions,
            selectedIndex: selectedRegionIndex,
            width: screenWidth * 0.25,
            onSelect: (index) {
              setState(() {
                selectedRegionIndex = index;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: RegionDetailGrid(
                details: detailList,
                crossAxisCount: crossAxisCount,
                onSelect: (detailRegion) {
                  _onRegionSelected(selectedRegion, detailRegion);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}