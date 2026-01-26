import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/region_detail_grid.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/region_list_panel.dart';

class SearchRegionScreen extends StatefulWidget {
  const SearchRegionScreen({super.key});

  @override
  State<SearchRegionScreen> createState() => _SearchRegionScreenState();
}

class _SearchRegionScreenState extends State<SearchRegionScreen> {
  int selectedRegionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final regions = RegionConstants.regions;
    final selectedRegion = regions[selectedRegionIndex];
    final detailList = RegionConstants.regionDetails[selectedRegion]!;

    final int crossAxisCount = screenWidth > AppBreakpoints.tablet
        ? 4
        : screenWidth > AppBreakpoints.mobile
        ? 3
        : 2;

    return Scaffold(
      appBar: const AppBarWidget(title: TitleLabels.selectRegion),
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
                  context.go(
                    '/search-filter',
                    extra: {
                      'detailRegion': detailRegion,
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}