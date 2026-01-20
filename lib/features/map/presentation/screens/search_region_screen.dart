import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/*
지역 선택 스크린
 */
class SearchRegionScreen extends StatefulWidget {
  const SearchRegionScreen({super.key});

  @override
  State<SearchRegionScreen> createState() => _SearchRegionScreenState();
}

class _SearchRegionScreenState extends State<SearchRegionScreen> {
  int selectedRegionIndex = 0;

  final List<String> regions = [
    '서울',
    '경기',
    '인천',
    '부산',
    '강원',
    '경상',
    '전라',
    '충청',
  ];

  final Map<String, List<String>> regionDetails = {
    '서울': [
      '전체', '종로', '중구', '용산', '성동', '광진', '동대문', '중랑',
      '성북', '강북', '도봉', '노원', '은평', '서대문', '마포',
      '양천', '강서', '구로', '금천', '영등포', '동작', '관악',
      '서초', '강남', '송파', '강동',
    ],
    '경기': ['전체', '수원', '성남', '용인', '고양'],
    '인천': ['전체', '중구', '남동구', '연수구'],
    '부산': ['전체', '해운대', '수영', '부산진'],
    '강원': ['전체', '강릉', '춘천'],
    '경상': ['전체', '대구', '포항'],
    '전라': ['전체', '전주', '광주'],
    '충청': ['전체', '대전', '청주'],
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedRegion = regions[selectedRegionIndex];
    final detailList = regionDetails[selectedRegion]!;


    final int crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
        ? 3
        : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 26),
                  ),
                  const Spacer(),
                  Text(
                    '지역 선택',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.06).clamp(20, 30),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            const Divider(height: 1),


            Expanded(
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.25,
                    constraints: const BoxConstraints(
                      minWidth: 120,
                      maxWidth: 260,
                    ),
                    color: const Color(0xFFF5F5F5),
                    child: ListView.builder(
                      itemCount: regions.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedRegionIndex;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedRegionIndex = index;
                            });
                          },
                          child: Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              regions[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: detailList.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 3,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                            },
                            child: Center(
                              child: Text(
                                detailList[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
