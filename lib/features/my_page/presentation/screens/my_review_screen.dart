import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/*
 * 마이페이지 - 내 리뷰 스크린 - only_app_style : 수정 필요.
 */
class MyreviewScreen extends StatefulWidget {
  const MyreviewScreen({super.key});

  @override
  State<MyreviewScreen> createState() => _MyreviewScreenState();
}

class _MyreviewScreenState extends State<MyreviewScreen> {
  // ✅ 더미 데이터 (나중에 API 연동 시 이 리스트만 교체하시면 됩니다)
  final List<_ReviewItem> _reviews = [
    _ReviewItem(
      hotelName: '롯데 호텔 명동',
      dateText: '2025.12.31',
      rating: 4.0,
      content: '방 컨디션이 매우 좋았습니다!\n재방문 의사 있습니다(단, 추워요)',
    ),
    _ReviewItem(
      hotelName: '신라스테이 역삼',
      dateText: '2025.12.22',
      rating: 3.0,
      content: '방은 깨끗해요. 다만 살짝 습한 감이요',
    ),
  ];

  Future<void> _confirmDelete(int index) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상단 닫기(선택)
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context, false),
                          icon: const Icon(Icons.close, size: 18),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 4),
                    const Text(
                      '리뷰를 삭제하시겠습니까?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF8E86C9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
        );
      },
    );

    if (result == true) {
      setState(() {
        _reviews.removeAt(index);
      });

      // TODO: 서버에 삭제 요청(API) 연결
      // 예) await reviewService.deleteReview(_reviews[index].reviewId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final maxWidth = w >= 600 ? 520.0 : double.infinity;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'),  // 추후 마이페이지로 변경
        ),
        title: const Text(
          '내 리뷰',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _reviews.isEmpty
              ? ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              SizedBox(height: 24),
              Text(
                '작성한 리뷰가 없습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _reviews[index];
              return _ReviewCard(
                item: item,
                onDeleteTap: () => _confirmDelete(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 카드 UI (쓰레기통 아이콘만 클릭 가능)
/// ===============================
class _ReviewCard extends StatelessWidget {
  final _ReviewItem item;
  final VoidCallback onDeleteTap;

  const _ReviewCard({
    required this.item,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0x558B8B8B)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 숙소명 + 삭제 아이콘(클릭 가능)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.hotelName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onDeleteTap, // ✅ 클릭되는 건 여기 뿐
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Color(0xFFFF2A2A),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // 날짜 + 별점
            Row(
              children: [
                Text(
                  item.dateText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B8B8B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                _StarRow(rating: item.rating),
              ],
            ),

            const SizedBox(height: 10),

            // 리뷰 내용 박스
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.content,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating; // 0.0 ~ 5.0
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < full; i++)
          const Icon(Icons.star, size: 14, color: Color(0xFF1E88FF)),
        if (hasHalf)
          const Icon(Icons.star_half, size: 14, color: Color(0xFF1E88FF)),
        for (int i = 0; i < empty; i++)
          const Icon(Icons.star_border, size: 14, color: Color(0xFF1E88FF)),
      ],
    );
  }
}

/// ===============================
/// 데이터 모델 (더미)
/// ===============================
class _ReviewItem {
  final String hotelName;
  final String dateText;
  final double rating;
  final String content;

  const _ReviewItem({
    required this.hotelName,
    required this.dateText,
    required this.rating,
    required this.content,
  });
}