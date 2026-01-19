import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  // Getters
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

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
      } else {
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
}
