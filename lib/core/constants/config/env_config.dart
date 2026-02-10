import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Meomulm';
  static String get kakaoNativeKey =>  dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  static String get kakaoLoginNativeKey =>  dotenv.env['KAKAO_NATIVE_APP_LOGIN_KEY'] ?? '';
  static String get naverLoginClientId =>  dotenv.env['NAVER_LOGIN_CLIENT_ID'] ?? '';
  static String get naverLoginClientSecret =>  dotenv.env['NAVER_LOGIN_CLIENT_SECRET'] ?? '';
  static String get naverLoginClientName =>  dotenv.env['NAVER_LOGIN_CLIENT_NAME'] ?? '';
  static String get cloudinaryCloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get cloudinaryUploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'product';

  static void printEnvInfo() {
    print('============ 환경 설정 ============');
    print('environment : $environment');
    print('API Base URL : $apiBaseUrl');
    print('APP Name : $appName');
    print('kakaoMapKey : ${kakaoNativeKey.isNotEmpty ? '설정됨': '미설정됨'}');
    print('kakaoLoginNativeKey : ${kakaoLoginNativeKey.isNotEmpty ? '설정됨': '미설정됨'}');
  }
}