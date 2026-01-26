/*
// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_response_model.dart';
import '../../data/datasources/product_api_service.dart';
import '../../data/models/product_model.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedDate = '12.31~01.01, 1박';
  String selectedPeople = '성인 3';

  List<Product> rooms = []; // ProductResponse 안의 rooms 리스트
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }


  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 날짜를 체크인/체크아웃으로 나누기
      final dates = selectedDate.split('~');
      final checkIn = dates[0].trim();
      final checkOut = dates[1].split(',')[0].trim(); // ", 1박" 제거

      final response = await ProductApiService.getRoomsByAccommodationId(
        accommodationId: 1,
        checkInDate: "2026-02-10",
        checkOutDate: "2026-02-15",
        guestCount: int.parse(selectedPeople.replaceAll(RegExp(r'[^0-9]'), '')),
      );

      setState(() {
        rooms = response.allProducts ?? []; // ProductResponse 안의 리스트
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 뒤로가기 + 타이틀 + 좋아요/공유 버튼
                Row(
                  children: [
                    const BackButton(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '그랜드 호스텔 LDK 명동',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        debugPrint('좋아요 클릭');
                      },
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.black87,
                    ),
                    IconButton(
                      onPressed: () {
                        debugPrint('공유 클릭');
                      },
                      icon: const Icon(Icons.ios_share),
                      color: Colors.black87,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 날짜 + 인원 선택 박스
                GestureDetector(
                  onTap: () {
                    context.go('/calendar');
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 20),
                            const SizedBox(width: 6),
                            Text(selectedDate,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 20),
                            const SizedBox(width: 6),
                            Text(selectedPeople,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 상품 카드 예시 (나중에 서버 데이터로 바꿀 수 있음)
                ProductCard(
                  title: '스탠다드',
                  price: '123,000원',
                  checkInfo: '체크인 15:00 ~ 체크아웃 11:00',
                  imageUrl: 'https://picsum.photos/357/163',
                  peopleInfo: '기준 3인 / 최대 3인',
                  facilities: [
                    '욕조',
                    '에어컨',
                    '냉장고',
                    '비데',
                    'TV',
                    'PC',
                    '세면도구'
                  ],
                  onTapReserve: () => context.go('/reservation'),
                ),
                const SizedBox(height: 20),
                ProductCard(
                  title: '더블 트윈베드',
                  price: '153,000원',
                  checkInfo: '체크인 15:00 ~ 체크아웃 11:00',
                  imageUrl: 'https://picsum.photos/357/163?2',
                  peopleInfo: '기준 3인 / 최대 3인',
                  facilities: [
                    '욕조',
                    '에어컨',
                    '냉장고',
                    '비데',
                    'TV',
                    'PC',
                    '세면도구'
                  ],
                  onTapReserve: () => context.go('/reservation'),
                ),
                const SizedBox(height: 20),
                ProductCard(
                  title: '프리미어 패밀리 트윈',
                  price: '203,000원',
                  checkInfo: '체크인 15:00 ~ 체크아웃 11:00',
                  imageUrl: 'https://picsum.photos/357/163?3',
                  peopleInfo: '기준 3인 / 최대 3인',
                  facilities: [
                    '욕조',
                    '에어컨',
                    '냉장고',
                    '비데',
                    'TV',
                    'PC',
                    '세면도구'
                  ],
                  onTapReserve: () => context.go('/reservation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/

// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/product_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedDate = '12.31~01.01, 1박';
  String selectedPeople = '성인 3';

  List<Product> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 날짜를 체크인/체크아웃으로 나누기
      final dates = selectedDate.split('~');
      final checkIn = dates[0].trim();
      final checkOut = dates[1].split(',')[0].trim();

      final response = await ProductApiService.getRoomsByAccommodationId(
        accommodationId: 1,
        checkInDate: "2026-02-10",
        checkOutDate: "2026-02-15",
        guestCount: int.parse(selectedPeople.replaceAll(RegExp(r'[^0-9]'), '')),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로가기 + 타이틀 + 좋아요/공유 버튼
              Row(
                children: [
                  const BackButton(),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '그랜드 호스텔 LDK 명동',
                      style: AppTextStyles.cardTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => debugPrint('좋아요 클릭'),
                    icon: const Icon(AppIcons.favorite),
                    color: AppColors.black
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
                onTap: () => context.go('/calendar'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(color: AppColors.gray2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(AppIcons.calendar, size: AppIcons.sizeMd),
                          const SizedBox(width: AppSpacing.sm),
                          Text(selectedDate, style: AppTextStyles.bodyMd),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(AppIcons.person, size: AppIcons.sizeMd),
                          const SizedBox(width: AppSpacing.sm),
                          Text(selectedPeople, style: AppTextStyles.bodyMd),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 서버 데이터 기반 ProductCard 리스트
              ...rooms.map((room) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ProductCard(
                    title: room.productName ?? '이름 없음',
                    price: '${room.productPrice ?? 0}원',
                    checkInfo: '체크인 ${room.productCheckInTime} ~ 체크아웃 ${room.productCheckOutTime}',
                    imageUrl: (room.images != null && room.images!.isNotEmpty)  ? room.images![0].productImageUrl ?? '' : '',
                    peopleInfo: '기준 ${room.productStandardNumber}인 / 최대 ${room.productMaximumNumber}인',
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
                    onTapReserve: () => context.go('/reservation'),
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

