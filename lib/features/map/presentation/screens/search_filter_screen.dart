import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/*
지도 검색 필터 스크린
 */
class SearchFilterScreen extends StatefulWidget {
  final Map<String, String>? regionData;

  const SearchFilterScreen({
    super.key,
    this.regionData,
  });

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  int guests = 2;
  String? selectedRegion;
  String? selectedDetailRegion;

  @override
  void initState() {
    super.initState();
    // 전달받은 지역 데이터 초기화
    if (widget.regionData != null) {
      selectedRegion = widget.regionData!['region'];
      selectedDetailRegion = widget.regionData!['detailRegion'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFC5C5C5), width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      '숙소 검색',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF939393)),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 5,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 지역 정보 표시
                        if (selectedDetailRegion != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '$selectedRegion > $selectedDetailRegion',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.pop(),
                                    child: const Text(
                                      '변경',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF9C95CA),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Divider(color: Color(0xFFC5C5C5)),
                              const SizedBox(height: 24),
                            ],
                          ),

                        Row(
                          children: const [
                            Icon(Icons.calendar_today, size: 24),
                            SizedBox(width: 12),
                            Text(
                              '2025년 12월 22일 - 2025년 12월 23일',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFC5C5C5)),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.people, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  '인원',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (guests > 1) {
                                      setState(() => guests--);
                                    }
                                  },
                                  icon: const Icon(Icons.remove, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$guests',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    setState(() => guests++);
                                  },
                                  icon: const Icon(Icons.add, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () {
                              // 검색 실행 로직
                              print('검색 실행: 지역=$selectedDetailRegion, 인원=$guests');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C95CA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              '검색',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}