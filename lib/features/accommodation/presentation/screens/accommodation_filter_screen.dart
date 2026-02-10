import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_price.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_section.dart';
import 'package:provider/provider.dart';


class AccommodationFilterScreen extends StatelessWidget {
  const AccommodationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilterProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(title: "숙소 필터"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppBorderRadius.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "필터 설정",
                        style: AppTextStyles.cardTitle
                      ),
                      TextButton.icon(
                        onPressed: () => provider.resetFilters(),
                        icon: const Icon(
                            AppIcons.refresh,
                            size: AppIcons.sizeSm,
                            color: AppColors.gray2
                        ),
                        label: const Text(
                          "초기화",
                          style: AppTextStyles.subTitleGrey
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xxxl),

                  AccommodationFilterSection(
                    title: '편의시설',
                    items: const [
                      '주차장', '전기차 충전', '흡연구역', '공용 와이파이',
                      '레저 시설', '운동 시설', '쇼핑 시설', '회의 시설', '레스토랑'
                    ],
                    selected: provider.facilities,
                    onToggle: (value) => provider.toggleFacility(value),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  AccommodationFilterSection(
                    title: '숙소 종류',
                    items: const [
                      '호텔', '리조트', '펜션', '모텔', '게스트하우스',
                      '글램핑', '캠프닉', '카라반', '오토캠핑', '캠핑', '기타'
                    ],
                    selected: provider.types,
                    onToggle: (value) => provider.toggleType(value),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  const AccommodationFilterPrice(),
                ],
              ),
            ),
          ),

          SafeArea(
            child: BottomActionButton(
              label: '적용하기',
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}