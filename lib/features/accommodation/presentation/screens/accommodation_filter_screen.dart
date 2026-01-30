import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_filter_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_price.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_section.dart';
import 'package:provider/provider.dart';

class AccommodationFilterScreen extends StatelessWidget {
  const AccommodationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationFilterProvider>();

    return Scaffold(
      appBar: AppBarWidget(title: "숙소 필터"),
      // 1. Column과 Expanded를 사용하여 레이아웃을 나눕니다.
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20), // 전체적인 여백 통일
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccommodationFilterSection(
                    title: '편의시설',
                    items: const [
                      '주차장', '전기차 충전', '흡연구역', '공용 와이파이', '레저 시설',
                    ],
                    selected: provider.facilities,
                    onToggle: provider.toggleFacility,
                  ),
                  const SizedBox(height: 40), // 섹션 간 간격을 시원하게 40으로 조정

                  AccommodationFilterSection(
                    title: '숙소 종류',
                    items: const [
                      '호텔', '모텔', '펜션', '풀빌라', '리조트', '게스트하우스', '콘도', '캠핑',
                    ],
                    selected: provider.types,
                    onToggle: provider.toggleType,
                  ),
                  const SizedBox(height: 40),

                  const AccommodationFilterPrice(),

                  // 스크롤 시 마지막 요소가 버튼에 가려지지 않도록 하단 여백 추가
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 2. 버튼을 SafeArea로 감싸서 기기 하단 바(Home Indicator)와 겹치지 않게 배치
          SafeArea(child: BottomActionButton(
            label: '적용하기',
            onPressed: () {
              Navigator.pop(context, provider.toQuery());
            },
          )),
        ],
      ),
    );
  }
}