import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvConfig {
  EnvConfig._();

  static String? _customApiBaseUrl;
  
  /// 커스텀 API URL 설정 (개발자 설정 화면에서 사용)
  static Future<void> setCustomApiBaseUrl(String? url) async {
    _customApiBaseUrl = url;
    final prefs = await SharedPreferences.getInstance();
    if (url != null && url.isNotEmpty) {
      await prefs.setString('custom_api_url', url);
    } else {
      await prefs.remove('custom_api_url');
    }
  }
  
  /// 저장된 커스텀 API URL 로드
  static Future<void> loadCustomApiBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _customApiBaseUrl = prefs.getString('custom_api_url');
  }
  
  /// API Base URL (플랫폼별 자동 선택)
  static String get apiBaseUrl {
    // 1. 커스텀 URL이 설정되어 있으면 우선 사용
    if (_customApiBaseUrl != null && _customApiBaseUrl!.isNotEmpty) {
      return _customApiBaseUrl!;
    }
    
    // 2. Web 환경: localhost 사용
    if (kIsWeb) {
      return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
    }
    
    // 3. 모바일 환경 (Android/iOS): PC IP 주소 사용
    return dotenv.env['API_BASE_URL_MOBILE'] ?? 
           dotenv.env['API_BASE_URL'] ?? 
           'http://192.168.0.237:8080/api';
  }
  
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Meomulm';
  static String get kakaoNativeKey => dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'product';

  static void printEnvInfo() {
    print('============ 환경 설정 ============');
    print('environment : $environment');
    print('API Base URL : $apiBaseUrl');
    print('플랫폼: ${kIsWeb ? "Web" : "Mobile"}');
    if (_customApiBaseUrl != null) {
      print('커스텀 URL: $_customApiBaseUrl');
    }
    print('APP Name : $appName');
    print('kakaoMapKey : ${kakaoNativeKey.isNotEmpty ? '설정됨': '미설정됨'}');
  }
}