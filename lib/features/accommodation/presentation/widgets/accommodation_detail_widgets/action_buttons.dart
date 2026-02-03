import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:meomulm_frontend/core/constants/config/env_config.dart';

class ActionButtons extends StatelessWidget {
  final int accommodationId;
  const ActionButtons({super.key, required this.accommodationId});

  /// deeplink URL 생성
  /// 예: https://meomulm.app/accommodation-detail/42
  static String _buildDeepLink(int id) {
    // TODO: 프로덕션 배포 시 아래 URL을 실제 도메인으로 교체
    // 예: https://meomulm.app/accommodation-detail/$id
    // 개발 단계에서는 커스탬 스키마 형태로도 사용 가능:
    //   meomulm://accommodation-detail/$id
    //
    // ▸ HTTPS Universal Link / App Link 방식 (권장)
    //   → assetlinks.json 및 apple-app-site-association 파일 배포 필요
    // ▸ Custom Scheme 방식 (빠르게 테스트하기 좋음)
    //   → AndroidManifest intent-filter 및 Flutter app 등록 필요
    //
    // 아래는 Custom Scheme 기준 구현. HTTPS로 전환하면 URL만 바꾸면 됨.
    return 'meomulm://accommodation-detail/$id';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(Icons.favorite_border),
        const SizedBox(width: 16),
        _buildShareButton(context),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final deepLink = _buildDeepLink(accommodationId);

        FlutterClipboard.copy(deepLink).then((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('링크가 복사되었습니다'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black87,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.share, color: Colors.white, size: 22),
      ),
    );
  }
}
