import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Meomulm';
  static String get kakaoNativeKey =>  dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'product';

  static void printEnvInfo() {
    print('============ 환경 설정 ============');
    print('environment : $environment');
    print('API Base URL : $apiBaseUrl');
    print('APP Name : $appName');
    print('kakaoMapKey : ${kakaoNativeKey.isNotEmpty ? '설정됨': '미설정됨'}');
  }
}