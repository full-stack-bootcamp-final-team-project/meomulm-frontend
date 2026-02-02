import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_price.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_section.dart';
import 'package:provider/provider.dart';


class AccommodationFilterScreen extends StatelessWidget {
  const AccommodationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 통합된 AccommodationProvider를 watch하여 UI 실시간 업데이트
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(title: "숙소 필터"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "필터 설정",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () => provider.resetFilters(),
                        icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                        label: const Text(
                          "초기화",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // 1. 편의시설 섹션 (Provider의 toggle 메서드 직접 호출)
                  AccommodationFilterSection(
                    title: '편의시설',
                    items: const [
                      '주차장', '전기차 충전', '흡연구역', '공용 와이파이',
                      '레저 시설', '운동 시설', '쇼핑 시설', '회의 시설', '레스토랑'
                    ],
                    selected: provider.facilities,
                    onToggle: (value) => provider.toggleFacility(value),
                  ),
                  const SizedBox(height: 40),

                  // 2. 숙소 종류 섹션
                  AccommodationFilterSection(
                    title: '숙소 종류',
                    items: const [
                      '호텔', '리조트', '펜션', '모텔', '게스트하우스',
                      '글램핑', '캠프닉', '카라반', '오토캠핑', '캠핑', '기타'
                    ],
                    selected: provider.types,
                    onToggle: (value) => provider.toggleType(value),
                  ),
                  const SizedBox(height: 40),

                  // 3. 가격 필터 (Provider 내부의 priceRange 사용)
                  const AccommodationFilterPrice(),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BottomActionButton(
                label: '적용하기',
                onPressed: () {
                  // 이미 Provider 상태가 업데이트되었으므로 바로 닫음
                  Navigator.pop(context, true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}