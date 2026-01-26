import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_filter_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_price.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/bottom_button_box.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/custom_appBar.dart';
import 'package:provider/provider.dart';


class AccommodationFilterScreen extends StatelessWidget {
  const AccommodationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationFilterProvider>();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(appBarTitle: '숙소 필터'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccommodationFilterSection(
                title: '편의시설',
                items: const [
                  '주차장',
                  '전기차 충전',
                  '흡연구역',
                  '공용 와이파이',
                  '레저 시설',
                ],
                selected: provider.facilities,
                onToggle: provider.toggleFacility,
              ),
              const SizedBox(height: 32),
              AccommodationFilterSection(
                title: '숙소 종류',
                items: const [
                  '호텔',
                  '모텔',
                  '펜션',
                  '풀빌라',
                  '리조트',
                  '게스트하우스',
                  '콘도',
                  '캠핑',
                ],
                selected: provider.types,
                onToggle: provider.toggleType,
              ),
              const SizedBox(height: 32),
              const AccommodationFilterPrice(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButtonBox(
        buttonName: '적용하기',
        onPressed: () {
          Navigator.pop(context, provider.toQuery());
        },
      ),
    );
  }
}
