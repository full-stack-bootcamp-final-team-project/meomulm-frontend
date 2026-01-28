import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_widgets/accommodation_image_slider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class AccommodationDetailScreen extends StatefulWidget {
  final int accommodationId;
  const AccommodationDetailScreen({super.key, required this.accommodationId});

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {
  Map<String, dynamic>? accommodationData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // 숙소 상세 DIO 요청
    fetchAccommodationDetail();
  }

  Future<void> fetchAccommodationDetail() async {
    try {
      final dio = Dio();
      // 예시 URL, 실제 API 경로로 변경
      final response = await dio.get('https://api.example.com/accommodations/${widget.accommodationId}');
      setState(() {
        accommodationData = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (2 / 5);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    // API 데이터 예시 구조에 맞게 가져오기
    final images = (accommodationData?['images'] as List<dynamic>? ?? []).cast<String>();
    final name = accommodationData?['name'] ?? '숙소명 없음';
    final rating = accommodationData?['rating']?.toString() ?? '0.0';
    final reviewCount = accommodationData?['reviewCount']?.toString() ?? '0';
    final description = accommodationData?['description'] ?? '';
    final address = accommodationData?['address'] ?? '';
    final contact = accommodationData?['contact'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccommodationImageSlider(
                  imageUrls: images.isNotEmpty ? images : ["assets/images/makao/makao.jpg"],
                  initialIndex: 0,
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFC1C1C1)),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(rating, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 6),
                              Text('리뷰 $reviewCount개', style: const TextStyle(fontSize: 14, decoration: TextDecoration.underline)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            description,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFC1C1C1)),
                          const SizedBox(height: 24),
                          // 숙소 정보 예시
                          ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4),
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 8,
                            leading: const Icon(Icons.circle, size: 6),
                            title: Row(
                              children: [
                                const Text('연락처 : ', style: TextStyle(fontSize: 14)),
                                Text(contact, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFC1C1C1)),
                          const SizedBox(height: 24),
                          Text('숙소 위치', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/address.svg', width: 16, height: 14),
                              const SizedBox(width: 6),
                              Text(address, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: address));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('주소가 복사되었습니다'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.black87,
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/images/copy.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: images.isNotEmpty
                                ? Image.network(images[0], width: double.infinity, height: imageHeight, fit: BoxFit.cover)
                                : Container(height: imageHeight, color: Colors.grey[200]),
                          ),
                          const SizedBox(height: 92),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
}
