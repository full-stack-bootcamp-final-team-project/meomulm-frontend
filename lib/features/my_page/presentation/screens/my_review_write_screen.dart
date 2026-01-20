import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/*
 * 마이페이지 - 리뷰 작성 스크린 - only_app_style : 수정 필요.
 */
class ReviewWriteScreen extends StatefulWidget {
  const ReviewWriteScreen({super.key});

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  double _rating = 0.0; // 0.0 ~ 5.0 (0.5 step)
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _ratingFromDx(double dx, double width) {
    final clamped = dx.clamp(0.0, width);
    final raw = (clamped / width) * 5.0; // 0~5
    final stepped = (raw * 2).round() / 2; // 0.5 단위
    return stepped.clamp(0.0, 5.0);
  }

  void _onSubmit() {
    // TODO: 실제 리뷰 등록 API 호출/검증 로직 추가 (필요 시)
    // 예) await reviewService.createReview(...);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('리뷰 등록이 완료되었습니다'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1200),
      ),
    );

    // TODO: "내 리뷰" 페이지로 이동
    // 예) context.go('/myreview');
    // 예) context.pop(); // 이전이 내 리뷰 페이지라면
    context.go('/my-reviews');
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
          onPressed: () {
            context.go('/my-reservation'); // 추후 마이페이지 경로로 변경
          },
        ),
        title: const Text(
          '리뷰 작성',
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                children: [
                  // 상단 예약 정보 카드
                  _ReservationInfoCard(),

                  const SizedBox(height: 14),

                  // 별점 영역 (0.5 단위 터치)
                  _RatingRow(
                    rating: _rating,
                    onChanged: (v) => setState(() => _rating = v),
                    ratingFromDx: _ratingFromDx,
                  ),

                  const SizedBox(height: 12),

                  // 리뷰 입력 박스
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '리뷰를 입력하세요.',
                          hintStyle: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 등록 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF9B93CF), // 사진 느낌의 보라색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '등록',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 상단 예약 정보 카드 (사진과 유사한 구조)
/// - 이미지: 회색 placeholder
/// - 호텔명/룸정보 + 체크인/체크아웃
/// ===============================
class _ReservationInfoCard extends StatelessWidget {
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
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Color(0xFF9E9E9E), size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '롯데 호텔 명동',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3),
                      Text(
                        '스탠다드 룸 · 1박',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B8B8B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  child: _MiniDateBlock(
                    label: '체크인',
                    value: '12.24 (수) 15:00',
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                Expanded(
                  child: _MiniDateBlock(
                    label: '체크아웃',
                    value: '12.25 (목) 11:00',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDateBlock extends StatelessWidget {
  final String label;
  final String value;

  const _MiniDateBlock({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8B8B8B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// 별점 Row
/// - 터치 위치에 따라 0.5 단위로 변경
/// - 별점 텍스트는 "x.x / 5.0"
/// ===============================
class _RatingRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final double Function(double dx, double width) ratingFromDx;

  const _RatingRow({
    required this.rating,
    required this.onChanged,
    required this.ratingFromDx,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HalfStarBar(
          rating: rating,
          onChanged: onChanged,
          ratingFromDx: ratingFromDx,
        ),
        const SizedBox(width: 10),
        Text(
          '${rating.toStringAsFixed(1)} / 5.0',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// 별 5개를 0.5 단위로 조절 가능한 바
/// - Drag/Touch로 조절
/// - material icon 사용
/// ===============================
class _HalfStarBar extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final double Function(double dx, double width) ratingFromDx;

  const _HalfStarBar({
    required this.rating,
    required this.onChanged,
    required this.ratingFromDx,
  });

  @override
  Widget build(BuildContext context) {
    const starSize = 24.0;
    const starColor = Color(0xFFBDBDBD); // 사진에서 옅은 별 느낌

    return LayoutBuilder(
      builder: (context, constraints) {
        // 별 영역의 실제 width (별 5개 + 간격)
        final width = (starSize * 5) + (4 * 6);

        return SizedBox(
          width: width,
          height: starSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => onChanged(ratingFromDx(d.localPosition.dx, width)),
            onHorizontalDragUpdate: (d) =>
                onChanged(ratingFromDx(d.localPosition.dx, width)),
            child: Row(
              children: List.generate(5, (i) {
                final starIndex = i + 1.0;

                IconData icon;
                if (rating >= starIndex) {
                  icon = Icons.star_rounded; // 꽉 찬 별
                } else if (rating >= starIndex - 0.5) {
                  icon = Icons.star_half_rounded; // 반 별
                } else {
                  icon = Icons.star_border_rounded; // 빈 별
                }

                return Padding(
                  padding: EdgeInsets.only(right: i == 4 ? 0 : 6),
                  child: Icon(
                      icon,
                      size: starSize,
                      color: (icon == Icons.star_rounded ||
                          icon == Icons.star_half_rounded)
                          ? Colors.amber            // 선택된 별만 amber
                          : const Color(0xFFBDBDBD) // 선택되지 않은 별
                  ),
                );

              }),
            ),
          ),
        );
      },
    );
  }
}