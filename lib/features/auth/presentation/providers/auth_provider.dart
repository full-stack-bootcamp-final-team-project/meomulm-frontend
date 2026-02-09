import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  // Getters
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null && _isTokenValid();

  /// JWT 토큰 유효성 검증 (만료 시간 체크)
  bool _isTokenValid() {
    if (_token == null) return false;

    try {
      // JWT는 header.payload.signature 형식
      final parts = _token!.split('.');
      if (parts.length != 3) return false;

      // payload 디코딩
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      // exp (만료 시간) 확인
      final exp = payloadMap['exp'] as int?;
      if (exp == null) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // 만료 5분 전이면 곧 만료될 것으로 간주
      final isExpired = now.isAfter(expiryDate.subtract(Duration(minutes: 5)));

      if (isExpired) {
        print('⚠️ 토큰이 만료되었거나 곧 만료됩니다.');
        print('   만료 시간: $expiryDate');
        print('   현재 시간: $now');
      }

      return !isExpired;
    } catch (e) {
      print('❌ 토큰 검증 실패: $e');
      return false;
    }
  }

  /// 로그인 처리 (토큰만 저장)
  Future<void> login(String token) async {
    _token = token;
    _isLoading = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    notifyListeners();
  }

  /// 로그아웃 처리
  Future<void> logout() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }

  /// 앱 시작 시 저장된 토큰 복원
  Future<void> loadSavedToken() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');

      if (savedToken != null && savedToken.isNotEmpty) {
        _token = savedToken;

        // 개선: 토큰 유효성 검증 추가
        if (!_isTokenValid()) {
          print('저장된 토큰이 만료되었습니다. 로그아웃 처리합니다.');
          await logout();  // 만료된 토큰 제거
          _token = null;
        } else {
          print(' 유효한 토큰을 불러왔습니다.');
        }
      } else {
        print('저장된 토큰이 없습니다. 로그인이 필요합니다.');
        _token = null;
      }
    } catch (e) {
      print('토큰 로드 실패: $e');
      _token = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 로딩 상태 수동 설정
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 토큰 만료까지 남은 시간 ( 디버깅용 )
  String? getTokenExpiryInfo() {
    if (_token == null) return null;

    try {
      final parts = _token!.split('.');
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      final exp = payloadMap['exp'] as int?;
      if (exp == null) return null;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final difference = expiryDate.difference(now);

      if (difference.isNegative) {
        return '만료됨 (${difference.abs().inDays}일 ${difference.abs().inHours % 24}시간 전)';
      } else {
        return '남은 시간: ${difference.inDays}일 ${difference.inHours % 24}시간 ${difference.inMinutes % 60}분';
      }
    } catch (e) {
      return '정보 없음';
    }
  }
}