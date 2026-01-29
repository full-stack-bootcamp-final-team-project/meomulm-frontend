import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/mypage_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';
/// ===============================
/// 유저 정보 관련 상태관리
/// ===============================
class UserProfileProvider with ChangeNotifier {
  final MypageService _mypageService = MypageService();
  UserProfileModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfileModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 유저 프로필 불러오기
  Future<void> loadUserProfile(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _mypageService.loadUserProfile(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}