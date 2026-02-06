import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_search_box.dart';
import 'package:provider/provider.dart';

import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/product_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_card.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> rooms = [];
  bool isLoading = true;
  bool isFavorite = false;

  DateTimeRange? dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );
  int guestCount = 2;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }


  Future<void> loadRooms() async {
    final provider = context.read<AccommodationProvider>();

    if (provider.selectedAccommodationId == null) {
      debugPrint('숙소 ID가 없습니다.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ProductApiService.getRoomsByAccommodationId(
        accommodationId: provider.selectedAccommodationId!,
        checkInDate: provider.checkIn.toIso8601String().split('T')[0],
        checkOutDate: provider.checkOut.toIso8601String().split('T')[0],
        guestCount: provider.guestNumber,
      );

      setState(() {
        rooms = response.allProducts ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    final accommodationName =
        provider.selectedAccommodationName ?? '숙소 이름';

    final selectedDate =
        '${provider.checkIn.month}.${provider.checkIn.day} ~ '
        '${provider.checkOut.month}.${provider.checkOut.day}';

    final selectedPeople = '성인 ${provider.guestNumber}';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              BackButton(color: AppColors.black),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  accommodationName,
                  style: AppTextStyles.appBarTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 좋아요 + 공유 버튼을 ActionButtons로 대체
              /* ProductActionButtons(
                accommodationId: provider.selectedAccommodationId ?? 0,
              ),*/
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md, // 간격 최소화
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 + 인원 선택 박스
            GestureDetector(
              onTap: () {
                final size = MediaQuery.of(context).size;
                final provider = context.read<AccommodationProvider>();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ProductSearchBox(
                        width: size.width * 0.9,
                        dateRange: provider.dateRange,
                        guestCount: provider.guestNumber,
                        onDateChanged: (newRange) {
                          if (newRange != null) {
                            provider.setSearchDate(
                                dateRangeValue: newRange);
                          }
                        },
                        onGuestChanged: (newCount) {
                          provider.setSearchDate(
                              guestNumberValue: newCount);
                        },
                        onApply: () {
                          Navigator.pop(context);
                          loadRooms();
                        },
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(color: AppColors.gray2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          AppIcons.calendar,
                          size: AppIcons.sizeMd,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          selectedDate,
                          style: AppTextStyles.bodyLg,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          AppIcons.person,
                          size: AppIcons.sizeMd,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          selectedPeople,
                          style: AppTextStyles.bodyLg,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 상품 리스트
            ...rooms.map((room) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: ProductCard(
                  productId: room.productId,
                  title: room.productName ?? '이름 없음',
                  price: room.productPrice ?? 0,
                  checkInfo:
                  '체크인 ${room.productCheckInTime} ~ 체크아웃 ${room.productCheckOutTime}',
                  imageUrl: (room.images != null &&
                      room.images!.isNotEmpty)
                      ? room.images![0].productImageUrl ?? ''
                      : '',
                  peopleInfo:
                  '기준 ${room.productStandardNumber}인 / 최대 ${room.productMaximumNumber}인',
                  facilities: [
                    if (room.facility?.hasBath == true) '욕조',
                    if (room.facility?.hasAirCondition == true) '에어컨',
                    if (room.facility?.hasRefrigerator == true)
                      '냉장고',
                    if (room.facility?.hasBidet == true) '비데',
                    if (room.facility?.hasTv == true) 'TV',
                    if (room.facility?.hasPc == true) 'PC',
                    if (room.facility?.hasInternet == true) '인터넷',
                    if (room.facility?.hasToiletries == true) '세면도구',
                  ],
                  images: room.images ?? [],
                  checkIn: provider.checkIn,
                  checkOut: provider.checkOut,
                  onTapReserve: () => context.push(AppRouter.RoutePaths.reservation),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_search_box.dart';
import 'package:provider/provider.dart';

import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/product_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_detail_widgets/product_card.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> rooms = [];
  bool isLoading = true;


  DateTimeRange? dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );
  int guestCount = 2;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    final provider = context.read<AccommodationProvider>();

    // 안전장치 (혹시 값이 없을 경우)
    if (provider.selectedAccommodationId == null) {
      debugPrint('숙소 ID가 없습니다.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ProductApiService.getRoomsByAccommodationId(
        accommodationId: provider.selectedAccommodationId!,
        checkInDate: provider.checkIn.toIso8601String().split('T')[0],
        checkOutDate: provider.checkOut.toIso8601String().split('T')[0],
        guestCount: provider.guestNumber,
      );

      setState(() {
        rooms = response.allProducts ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    final accommodationName =
        provider.selectedAccommodationName ?? '숙소 이름';

    final selectedDate =
        '${provider.checkIn.month}.${provider.checkIn.day} ~ '
        '${provider.checkOut.month}.${provider.checkOut.day}';

    final selectedPeople = '성인 ${provider.guestNumber}';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로가기 + 타이틀 + 좋아요/공유
              Row(
                children: [
                  const BackButton(),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      accommodationName,
                      style: AppTextStyles.cardTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => debugPrint('좋아요 클릭'),
                    icon: const Icon(AppIcons.favorite),
                    color: AppColors.black,
                  ),
                  IconButton(
                    onPressed: () => debugPrint('공유 클릭'),
                    icon: const Icon(Icons.ios_share),
                    color: AppColors.black,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 날짜 + 인원 선택 박스
              GestureDetector(
                onTap: () {
                  final size = MediaQuery.of(context).size;

                  final provider = context.read<AccommodationProvider>();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: ProductSearchBox(
                          width: size.width * 0.9,
                          dateRange: provider.dateRange,
                          guestCount: provider.guestNumber,
                          onDateChanged: (newRange) {
                            if (newRange != null) {
                              provider.setSearchDate(dateRangeValue: newRange);
                            }
                          },
                          onGuestChanged: (newCount) {
                            provider.setSearchDate(guestNumberValue: newCount);
                          },
                          onApply: () {
                            Navigator.pop(context); // 모달 닫기
                            loadRooms();            // 선택값으로 다시 로드
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(color: AppColors.gray2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            AppIcons.calendar,
                            size: AppIcons.sizeMd,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            selectedDate,
                            style: AppTextStyles.bodyMd,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            AppIcons.person,
                            size: AppIcons.sizeMd,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            selectedPeople,
                            style: AppTextStyles.bodyMd,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 상품 리스트
              ...rooms.map((room) {

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ProductCard(
                    productId: room.productId,
                    title: room.productName ?? '이름 없음',
                    price: room.productPrice ?? 0,
                    checkInfo:
                    '체크인 ${room.productCheckInTime} ~ 체크아웃 ${room.productCheckOutTime}',
                    imageUrl: (room.images != null &&
                        room.images!.isNotEmpty)
                        ? room.images![0].productImageUrl ?? ''
                        : '',
                    peopleInfo:
                    '기준 ${room.productStandardNumber}인 / 최대 ${room.productMaximumNumber}인',
                    facilities: [
                      if (room.facility?.hasBath == true) '욕조',
                      if (room.facility?.hasAirCondition == true) '에어컨',
                      if (room.facility?.hasRefrigerator == true) '냉장고',
                      if (room.facility?.hasBidet == true) '비데',
                      if (room.facility?.hasTv == true) 'TV',
                      if (room.facility?.hasPc == true) 'PC',
                      if (room.facility?.hasInternet == true) '인터넷',
                      if (room.facility?.hasToiletries == true) '세면도구',
                    ],
                    images: room.images ?? [],
                    onTapReserve: () => context.push('/reservation'),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}


*/