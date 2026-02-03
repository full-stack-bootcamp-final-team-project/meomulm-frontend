import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/intro/presentation/widget/loading_bar_widget.dart';
import 'package:meomulm_frontend/features/intro/presentation/widget/logo_widget.dart';
import '../../../../core/widgets/dialogs/error_dialog.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {

  // 애니메이션 관련
  late AnimationController _controller; // 애니메이션을 시간으로 제어
  late Animation<double> _animation; // 0.0 ~ 1.0 진행률 애니메이션

  // 상태 관리
  bool _isAnimationDone = false; // 애니메이션 종료 여부
  bool _isHomeReady = false;     // 초기 데이터 준비 완료 여부
  bool _isNavigated = false;     // 홈 화면 이동 여부 (중복 방지)
  bool _isDialogShowing = false; // 에러 다이얼로그 중복 방지

  // 경고 타이머
  Timer? _softErrorTimer;        // 5초 후 경고
  Timer? _hardErrorTimer;        // 30초 후 치명적 오류

  // 로딩바 Key (강제로 재생성할 때 사용)
  Key _loadingBarKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    // Intro 진입과 동시에 에러 타이머 시작
    _startErrorTimers();

    // 애니메이션 컨트롤러 초기화 (3초)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // 애니메이션 완료 시 상태 업데이트
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimationDone = true;
        _checkAndNavigate(); // 애니메이션 + 홈 준비 완료 시 이동
      }
    });

    // 애니메이션 시작
    _controller.forward();

    // 홈 화면 준비 (API 호출 등)
    _prepareHome();
  }

  /// ========================== 홈 화면 준비 ==========================
  Future<void> _prepareHome() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // ✅ 테스트용 정상
      // await Future.delayed(const Duration(seconds: 100)); // 🔥 테스트용 지연
      _isHomeReady = true;
      // 준비 완료 시 이동
      _checkAndNavigate();
    } catch (_) {
      // 실패 시 대기
    }
  }

  /// ========================== 화면 이동 체크 ==========================
  /// 애니메이션 + 홈 준비가 완료되면 홈으로 이동
  void _checkAndNavigate() {
    if (_isNavigated) return; // 중복 이동 방지

    if (_isAnimationDone && _isHomeReady && mounted) {
      _isNavigated = true;
      _cancelTimers(); // 타이머 해제
      context.go(RoutePaths.home); // 홈 화면 이동
    }
  }

  /// ========================== 에러 타이머 ==========================
  void _startErrorTimers() {
    // 기존 타이머 취소
    _cancelTimers();

    // ⚠️ 5초 경고 (재시도 가능)
    _softErrorTimer = Timer(const Duration(seconds: 5), () {
      if (!_isHomeReady && mounted) {
        _showErrorDialog(
          message: '네트워크 연결이 원활하지 않습니다.\n다시 접속해주세요.',
          isHard: false,
        );
      }
    });

    // 🚨 30초 오류
    _hardErrorTimer = Timer(const Duration(seconds: 27), () {
      if (!_isHomeReady && mounted) {
        // 소프트 에러 다이얼로그가 떠있으면 닫기
        _isDialogShowing = false;
        Navigator.of(context, rootNavigator: true).pop();

        _showErrorDialog(
          message: '서버에 연결할 수 없습니다.\n잠시 후 다시 시도해주세요.',
          isHard: true,
        );
      }
    });
  }

  /// ========================== Intro 상태 리셋 ==========================
  /// 소프트 에러에서 "다시 시도" 버튼 눌렀을 때 호출
  void _resetIntro() {
    _cancelTimers();

    _isAnimationDone = false;
    _isHomeReady = false;
    _isNavigated = false;

    // 프로그래스바 재생성
    _loadingBarKey = UniqueKey();

    _controller.reset();
    _controller.forward();

    _startErrorTimers();
    _prepareHome();


    setState(() {}); // UI 갱신
  }

  /// ========================== 에러 다이얼로그 ==========================
  /// isHard: true → 앱 종료 / 재시도 불가
  /// isHard: false → 소프트 에러, 다시 시도 가능
  void _showErrorDialog({required String message, required bool isHard}) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ErrorDialog(
        message: message,
        onConfirm: () {
          _isDialogShowing = false;
          if (!isHard) _resetIntro(); // 소프트 에러 → 재시도
          // isHard면 앱 종료나 다른 처리 가능
        },
      ),
    );
  }

  /// ========================== 타이머 해제 ==========================
  void _cancelTimers() {
    _softErrorTimer?.cancel();
    _hardErrorTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimers();
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  /// ========================== UI 구성 ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 화면 전체 크기
        width: double.infinity,
        height: double.infinity,

        // 배경 그라디언트
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA7A6CB),
              Color(0xFFE56E50),
            ],
            stops: [0.0, 1.0],
          ),
        ),


        child: SafeArea(
          child: Stack(
            children: [
              // 중앙 로고
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 150),
                  child: LogoWidget(),
                ),
              ),

              // 하단 로딩바 + 자동차 아이콘 + 집 아이콘 + 로딩 텍스트
              Positioned(
                left: 30,
                right: 30,
                bottom: 120,
                child:  LoadingBarWidget(
                  key: _loadingBarKey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
