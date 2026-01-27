import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_widgets/accommodation_image_slider.dart';
import 'package:provider/provider.dart';



class AccommodationDetailScreen extends StatelessWidget {
  const AccommodationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (2 / 5);

    final List<String> imageUrls = [
      "assets/images/makao/makao.jpg",
      "assets/images/makao/makao(1).jpg",
      "assets/images/makao/makao(2).jpg",
      "assets/images/makao/makao(3).jpg",
      "assets/images/makao/makao(4).jpg",
      "assets/images/makao/makao(5).jpg",
    ];

    return Consumer<AccommodationProvider>(
        builder: (context, provider, child) {
          final id = provider.accommodationId ?? 'unknown';
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 이미지 + 뒤로가기 버튼 + 액션 버튼들
                      // Stack(
                      //   children: [
                      //     // 큰 이미지 (상단 231px 높이)
                      //     Container(
                      //       width: double.infinity,
                      //       height: 300,
                      //       decoration: const BoxDecoration(
                      //         image: DecorationImage(
                      //           image: NetworkImage(
                      //               "https://img.travel.rakuten.co.jp/share/image_up/25446/LARGE/e0a3459eee987f36583183257364b4a27c5bed18.47.9.26.3.jpg"
                      //           ),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     // 뒤로가기 버튼 (기존 CommonBackButton 재사용)
                      //     const CommonBackButton(
                      //       backgroundColor: Color(0xFF303030),
                      //       iconColor: Colors.white,
                      //     ),
                      //
                      //     // 오른쪽 상단 액션 버튼들 (좋아요 + 공유)
                      //     Positioned(
                      //       top: 16,
                      //       right: 16,
                      //       child: const ActionButtons(),
                      //     ),
                      //
                      //     // 이미지 개수 표시 (1/121)
                      //     Positioned(
                      //       bottom: 36,
                      //       right: 16,
                      //       child: Container(
                      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      //         decoration: BoxDecoration(
                      //           color: Colors.black.withOpacity(0.7),
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         child: const Text(
                      //           '1/121',
                      //           style: TextStyle(color: Colors.white, fontSize: 12),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      AccommodationImageSlider(
                        imageUrls: imageUrls,
                        initialIndex: 0,
                      ),

                      // 2. 숙소명 + 리뷰 요약
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),

                              const Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: const Text(
                                  '서울신라호텔',
                                  style: TextStyle(fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),

                              const SizedBox(height: 24),
                              const Divider(height: 1,
                                  thickness: 1,
                                  color: Color(0xFFC1C1C1)),
                              const SizedBox(height: 24),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.star, color: Colors.amber,
                                            size: 20),
                                        const SizedBox(width: 4),
                                        const Text('4.2', style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 6),
                                        const Text(
                                          '리뷰 652개',
                                          style: TextStyle(fontSize: 14,
                                              decoration: TextDecoration
                                                  .underline),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '“매우 특별한 호텔로, 비즈니스 지역에 위치해 있으며, 지하철 이용이 편리하고, 도심에 · · ·',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),
                              const Divider(height: 1,
                                  thickness: 1,
                                  color: Color(0xFFC1C1C1)),
                              const SizedBox(height: 24),

                              // 3. 시설/서비스 (6개 기본 + 더보기)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '시설/서비스',
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    const _FacilityList(initialShowCount: 6),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),
                              const Divider(height: 1,
                                  thickness: 1,
                                  color: Color(0xFFC1C1C1)),
                              const SizedBox(height: 24),

                              // 4. 숙소 정보
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '숙소 정보',
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                        children: [
                                          ListTile(
                                            dense: true,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            minVerticalPadding: 0,
                                            contentPadding: EdgeInsets.zero,
                                            minLeadingWidth: 8,
                                            leading: const Icon(
                                                Icons.circle, size: 6),
                                            title: Row(
                                              children: const [
                                                Text(
                                                  '연락처 : ',
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  '010-1234-1234',
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ]
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              // 구분선 3
                              const Divider(height: 1,
                                  thickness: 1,
                                  color: Color(0xFFC1C1C1)),

                              const SizedBox(height: 24),

                              // 5. 숙소 규정
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '숙소 규정',
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 12),

                                    Column(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          visualDensity: const VisualDensity(
                                              vertical: -4),
                                          minVerticalPadding: 0,
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 8,
                                          leading: Icon(Icons.circle, size: 6),
                                          title: Text(
                                            '미성년자는 예약 및 숙박 불가합니다.',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        ListTile(
                                          dense: true,
                                          visualDensity: const VisualDensity(
                                              vertical: -4),
                                          minVerticalPadding: 0,
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 8,
                                          leading: Icon(Icons.circle, size: 6),
                                          title: Text(
                                            '2인 초과 인원은 추가 요금이 발생합니다.',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        ListTile(
                                          dense: true,
                                          visualDensity: const VisualDensity(
                                              vertical: -4),
                                          minVerticalPadding: 0,
                                          contentPadding: EdgeInsets.zero,
                                          minLeadingWidth: 8,
                                          leading: Icon(Icons.circle, size: 6),
                                          title: Text(
                                            '체크인 기준 3일 전까지 예약 취소 가능합니다.',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),


                              const SizedBox(height: 32),

                              // 구분선 4
                              const Divider(height: 1,
                                  thickness: 1,
                                  color: Color(0xFFC1C1C1)),

                              const SizedBox(height: 24),

                              // 6. 숙소 위치
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '숙소 위치',
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(
                                    //       'assets/images/address.svg',
                                    //       width: 16,
                                    //       height: 16,
                                    //     ),
                                    //     const SizedBox(width: 6),
                                    //     const Text(
                                    //       '서울 중구 동호로 249',
                                    //       style: TextStyle(fontSize: 14),
                                    //     ),
                                    //     const SizedBox(width: 6),
                                    //     SvgPicture.asset(
                                    //       'assets/images/copy.svg',
                                    //       width: 18,
                                    //       height: 18,
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/address.svg',
                                          width: 16,
                                          height: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          '서울 중구 동호로 249',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(width: 8),
                                        // 아이콘과 텍스트 사이 간격 조정

                                        // 복사 아이콘 + 클릭 시 복사 기능
                                        GestureDetector(
                                          onTap: () {
                                            // 주소 복사
                                            Clipboard.setData(
                                              const ClipboardData(
                                                  text: '서울 중구 동호로 249'),
                                            );

                                            // 복사 완료 토스트
                                            ScaffoldMessenger
                                                .of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('주소가 복사되었습니다'),
                                                duration: Duration(seconds: 2),
                                                behavior: SnackBarBehavior
                                                    .floating,
                                                backgroundColor: Colors.black87,
                                              ),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/copy.svg',
                                            width: 18,
                                            height: 18,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://th.bing.com/th/id/OIP.HzdMx7fDTGB1mMOvHyx43wHaES?w=326&h=189&c=7&r=0&o=7&pid=1.7&rm=3',
                                        width: double.infinity,
                                        height: imageHeight,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 92),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 하단 고정 버튼
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomActionButton(label: "모든 객실 보기"),
                ),
              ],
            ),
          );
        }
    );
  }
}


// 시설/서비스 리스트 위젯 (2열 + 6개 기본 + 더보기)
class _FacilityList extends StatefulWidget {
  final int initialShowCount;

  const _FacilityList({required this.initialShowCount});

  @override
  State<_FacilityList> createState() => _FacilityListState();
}

class _FacilityListState extends State<_FacilityList> {
  static const List<String> _facilities = [
    '주차장',
    '흡연 구역',
    '레저 시설',
    '전기차 충전',
    '무선인터넷',
    '스포츠 시설',
    '피트니스 센터',
    '수영장',
    '사우나',
    '키즈 클럽',
    '룸서비스',
    '컨시어지',
  ];

  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final displayItems = _showAll ? _facilities : _facilities.take(widget.initialShowCount).toList();
    final hasMore = _facilities.length > widget.initialShowCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: displayItems.map((item) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 36 - 16) / 2, // 2열
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.black),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF111111)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        if (hasMore && !_showAll)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () => setState(() => _showAll = true),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6C6C6C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF6C6C6C), size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }
}