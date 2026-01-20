import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/**
 * 마이페이지 스크린 - only_app_style : 수정 필요.
 */
class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  // =====================
  // 로그아웃 확인 모달
  // =====================
  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return _ConfirmActionDialog(
          message: '로그아웃 하시겠습니까?',
          cancelText: '취소',
          confirmText: '로그아웃',
          confirmColor: const Color(0xFF8E86C9), // 기존 스타일(보라)
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            Navigator.pop(context);
            // TODO: 로그아웃 처리 (토큰 삭제/세션 종료 등)
            // TODO: 로그아웃 후 이동 (예: context.go('/login');)
          },
        );
      },
    );
  }

  // =====================
  // 회원탈퇴 확인 모달
  // =====================
  Future<void> _showWithdrawDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return _ConfirmActionDialog(
          message: '탈퇴를 진행하시겠습니까?',
          cancelText: '취소',
          confirmText: '회원탈퇴',
          confirmColor: const Color(0xFFFF2A2A), // 탈퇴는 빨강 느낌
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            Navigator.pop(context);
            // TODO: 회원탈퇴 API 호출
            // TODO: 탈퇴 완료 후 이동 (예: context.go('/goodbye'); or context.go('/login');)
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? screenWidth : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: const Text(
          '내 정보',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              const Divider(color: Color(0xFFC5C5C5), height: 1),
              const SizedBox(height: 20),

              // =====================
              // 프로필 영역
              // =====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ProfileAvatar(
                      onCameraTap: () {
                        // TODO: 프로필 사진 변경 로직 연결
                      },
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'gangster@exam.com',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '홍길동',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =====================
              // 아이콘 메뉴
              // =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _IconMenuButton(
                      icon: Icons.favorite_border_rounded,
                      label: '찜 목록',
                      onTap: () {
                        // TODO: 페이지 이동 로직 (예: context.push('/favorite'))
                      },
                    ),
                  ),
                  Expanded(
                    child: _IconMenuButton(
                      icon: Icons.comment,
                      label: '내 리뷰',
                      onTap: () {
                        // TODO: 페이지 이동 로직 (예: context.push('/my-reviews'))
                        context.go('/my-reviews');
                      },
                    ),
                  ),
                  Expanded(
                    child: _IconMenuButton(
                      icon: Icons.calendar_month,
                      label: '예약 내역',
                      onTap: () {
                        // TODO: 페이지 이동 로직 (예: context.push('/reservations'))
                        context.go('/my-reservation');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Color(0xFF8B8B8B), height: 1),
              const SizedBox(height: 12),

              // =====================
              // 하단 메뉴 리스트
              // =====================
              _MenuItem(
                title: '회원정보 수정',
                onTap: () {
                  context.go('/profile/edit');
                },
              ),
              _MenuItem(
                title: '비밀번호 수정',
                onTap: () {
                  context.go('/change-password');
                },
              ),
              _MenuItem(
                title: '로그아웃',
                onTap: () => _showLogoutDialog(context), // ✅ 추가
              ),
              _MenuItem(
                title: '회원탈퇴',
                textColor: Colors.red,
                onTap: () => _showWithdrawDialog(context), // ✅ 추가
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// 공통: 확인 모달(로그아웃/회원탈퇴 재사용)
// =====================
class _ConfirmActionDialog extends StatelessWidget {
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _ConfirmActionDialog({
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.confirmColor,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            // ✅ 모달 내부 여백(원하시면 여기 값을 조절)
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            child: ConstrainedBox(
              // 화면/텍스트에 따라 너무 넓어지는 것 방지
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 14),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 버튼 2개: 취소 / 확인(로그아웃 or 회원탈퇴)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Colors.black,
                            ),
                            child: Text(
                              cancelText,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: confirmColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              confirmText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 우측 상단 닫기(X)
          Positioned(
            right: 6,
            top: 6,
            child: IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.close, size: 18),
              splashRadius: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// 프로필 아바타 (카메라 탭 가능)
// =====================
class _ProfileAvatar extends StatelessWidget {
  final VoidCallback? onCameraTap;

  const _ProfileAvatar({this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCFCFCF)),
            ),
            child: const Center(
              child: Icon(
                Icons.account_circle,
                size: 56,
                color: Color(0xFFCFCFCF),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: InkWell(
              onTap: onCameraTap,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCFCFCF)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// 상단 아이콘 메뉴 버튼
// =====================
class _IconMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// 메뉴 항목
// =====================
class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuItem({
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}