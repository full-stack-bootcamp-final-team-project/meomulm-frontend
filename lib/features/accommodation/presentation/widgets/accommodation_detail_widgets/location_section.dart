import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';

class LocationSection extends StatelessWidget {
  final String address;
  final double mapHeight;
  final double latitude;
  final double longitude;

  const LocationSection({
    super.key,
    required this.address,
    required this.mapHeight,
    required this.latitude,
    required this.longitude,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: address));
    SnackMessenger.showMessage(
        context,
        "주소가 복사되었습니다.",
        bottomPadding: 85,
        type: ToastType.success
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '숙소 위치',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/accommodation/address.svg',
                width: 16,
                height: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: const Icon(Icons.copy, size: 18, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
                width: 1,
              ),
              boxShadow: AppShadows.card, // 정상 적용
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: mapHeight,
                width: double.infinity,
                // child: Stack(
                //   children: [
                //     Positioned.fill(
                //       child: Image.network(
                //         'https://static-maps.yandex.ru/1.x/?ll=$longitude,$latitude&z=15&size=650,450&l=map',
                //         fit: BoxFit.cover,
                //         loadingBuilder: (context, child, loadingProgress) {
                //           if (loadingProgress == null) return child;
                //           return Container(
                //             color: Colors.grey[200],
                //             child: const Center(child: CircularProgressIndicator()),
                //           );
                //         },
                //         errorBuilder: (context, error, stackTrace) {
                //           return Container(
                //             color: Colors.grey[200],
                //             child: const Center(
                //               child: Icon(Icons.error_outline, color: Colors.grey),
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //     const Center(
                //       child: Padding(
                //         padding: EdgeInsets.only(bottom: 35),
                //         child: Icon(
                //           Icons.location_on,
                //           color: Colors.red,
                //           size: 40,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                child: KakaoMap(
                  onMapReady: (controller) async {
                    LatLng myPosition = LatLng(latitude, longitude);

                    await controller.labelLayer.addPoi(
                      myPosition,
                      style: PoiStyle(
                        // icon: KImage.fromAsset('assets/markers/my_location.png', 34, 50),
                      ),
                    );

                    controller.moveCamera(CameraUpdate.newCenterPosition(myPosition));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}