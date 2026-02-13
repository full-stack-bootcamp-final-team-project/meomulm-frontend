# 머묾 (Meomulm) - 숙박 예약 플랫폼

> 전국의 숙박시설을 한눈에 검색하고 예약할 수 있는 Flutter 기반 모바일 애플리케이션

## 목차

- [**프로젝트 소개**](#프로젝트-소개)
- [**팀원 소개**](#팀원-소개)
- [**주요 기능**](#주요-기능)
- [**기술 스택**](#기술-스택)
- [**시작하기**](#시작하기)
- [**프로젝트 구조**](#프로젝트-구조)
- [**환경 설정**](#환경-설정)
- [**개발 가이드**](#개발-가이드)
- [**빌드 및 배포**](#빌드-및-배포)
- [**테스트**](#테스트)
- [**트러블슈팅**](#트러블슈팅)

---

## 프로젝트 소개

**머묾**(**Meomulm**)은 다양한 숙박시설(호텔, 모텔, 펜션, 캠핑, 글램핑 등)을  
검색하고 예약할 수 있는 **크로스플랫폼 모바일 애플리케이션**입니다.  
카카오맵 기반의 직관적인 지도 검색과 간편 결제 시스템을 제공합니다.

### 주요 특징

- 카카오맵 기반 지도 검색
- 소셜 로그인 지원 (카카오, 네이버, 구글)
- Stripe 간편 결제
- STOMP 기반 실시간 채팅
- Android / iOS / Web 크로스플랫폼 지원

---

## 팀원 소개

### Frontend Team (6명)

| 이름  | 역할                                                                 | 담당 기능                              | GitHub                                        |
|:----|:-------------------------------------------------------------------|:-----------------------------------|:----------------------------------------------|
| 유기태 | Frontend Lead & Map Feature Owner                                  | 아키텍처 설계, 코어 모듈 구축 및 지도 기능 구현       | [tiradovi](https://github.com/tiradovi)       |
| 박형빈 | Frontend Developer (Auth & Social Login Feature Owner)             | 사용자 인증 및 소셜 로그인 기능 구현              | [PHB-1994](https://github.com/PHB-1994)       |
| 조연희 | Frontend Developer (Core UI, App Entry & Chatbot Feature Owner)    | 글로벌 테마 시스템 구축, 홈/인트로 화면 및 챗봇 기능 구현 | [yeonhee-cho](https://github.com/yeonhee-cho) |
| 박세원 | Frontend Developer (Accommodation Search Feature Owner)            | 필터링 기반 숙소 검색 로직 구현 및 알림 연동         | [svv0003](https://github.com/svv0003)         |
| 현윤선 | Frontend Developer (Booking API Integration & Payment with Stripe) | 예약 API 연동 및 Stripe 기반 결제 흐름 구현     | [yunseonhyun](https://github.com/yunseonhyun) |
| 오유성 | Frontend Developer (MyPage & Review Feature Owner)                 | 마이페이지 UI 및 사용자 리뷰 기능 구현            | [Emma10003](https://github.com/Emma10003)     |

---

## 주요 기능

### 사용자 인증

- 이메일 로그인 / 회원가입
- 소셜 로그인 (카카오톡 & 네이버)
- 비밀번호 재설정
- 아이디 찾기 및 비밀번호 변경

### 숙박시설 검색

- 지도 검색
- 키워드 기반 숙소 검색
- 편의시설, 가격, 지역, 인원수, 예약날짜 기반 필터링

### 예약 및 결제

- 예약 추가 및 Stripe 기반 결제

### 리뷰 / 찜 / 챗봇 / 알림

- 숙소별 별점 리뷰 생성 및 조회
- 찜 목록 추가 및 조회
- 챗봇 (Rule-based with LLM fallback chatbot)
- 푸시 알림

---

## 기술 스택

### Framework

- Flutter
- Dart

### 상태관리

- Provider

### 네트워크

- Dio

### 지도

- Kakao Map SDK

### 결제

- Stripe

### 실시간

- STOMP

---

## 시작하기

### 요구사항

- Flutter 3.10+
- Android Studio / Xcode

### 설치

### 설치 및 실행

1. **저장소 클론**

```bash
git clone https://github.com/your-repo/meomulm-frontend.git
cd meomulm-frontend
```

2. **의존성 설치**

```bash
flutter pub get
```

3. **환경변수 설정**
   프로젝트 루트에 `.env.development` 파일 생성:

```env
# API
API_BASE_URL=https://api.example.com

# Kakao
KAKAO_NATIVE_KEY=your_kakao_native_key
KAKAO_JAVASCRIPT_KEY=your_kakao_js_key

# Naver
NAVER_CLIENT_ID=your_naver_client_id
NAVER_CLIENT_SECRET=your_naver_client_secret

# Stripe
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

4. **코드 생성**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **앱 실행**

```bash
# 개발 모드
flutter run

# 특정 디바이스
flutter run -d chrome  # 웹
flutter run -d android # Android
flutter run -d ios     # iOS
```

## 프로젝트 구조

```
meomulm-frontend/
├── android/                    # Android 네이티브 설정
├── ios/                        # iOS 네이티브 설정
├── web/                        # Web 설정
├── assets/                     # 리소스 파일
│   ├── images/                 # 이미지 파일
│   │   ├── accommodation/      # 숙박시설 기본 이미지
│   │   └── ad/                 # 광고 이미지
│   └── markers/                # 지도 마커 이미지
├── lib/
│   ├── core/                   # 핵심 기능
│   │   ├── constants/          # 상수 정의
│   │   │   ├── config/         # 앱 설정
│   │   │   ├── paths/          # 라우트/API 경로
│   │   │   └── ui/             # UI 상수
│   │   ├── error/              # 에러 핸들링
│   │   ├── providers/          # 전역 Provider
│   │   ├── router/             # 라우팅 설정
│   │   ├── theme/              # 테마 및 스타일
│   │   ├── utils/              # 유틸리티 함수
│   │   └── widgets/            # 공통 위젯
│   │       ├── appbar/         # 앱바 위젯
│   │       ├── buttons/        # 버튼 위젯
│   │       ├── dialogs/        # 다이얼로그
│   │       ├── input/          # 입력 위젯
│   │       ├── layouts/        # 레이아웃 위젯
│   │       └── search/         # 검색 위젯
│   ├── features/               # 기능별 모듈
│   │   ├── accommodation/      # 숙박시설
│   │   │   ├── data/           # 데이터 레이어
│   │   │   │   ├── datasources/  # API 서비스
│   │   │   │   └── models/       # 데이터 모델
│   │   │   └── presentation/   # UI 레이어
│   │   │       ├── providers/    # 상태 관리
│   │   │       ├── screens/      # 화면
│   │   │       └── widgets/      # 위젯
│   │   ├── auth/               # 인증
│   │   ├── chat/               # 채팅
│   │   ├── home/               # 홈
│   │   ├── intro/              # 인트로
│   │   ├── map/                # 지도
│   │   ├── my_page/            # 마이페이지
│   │   └── reservation/        # 예약
│   ├── app.dart                # 앱 진입점
│   └── main.dart               # 메인 함수
├── .env.development            # 개발 환경변수
├── .env.product                # 프로덕션 환경변수
├── pubspec.yaml                # 패키지 의존성
└── README.md                   # 프로젝트 문서
```

### Clean Architecture 기반 구조

```
feature/
├── data/
│   ├── datasources/    # API 통신, 로컬 저장소
│   └── models/         # 데이터 모델 (DTO)
└── presentation/
    ├── providers/      # 상태 관리 (Provider)
    ├── screens/        # 화면 (Page)
    └── widgets/        # UI 컴포넌트
```

## 환경 설정

### 개발 환경 (.env.development)

- 로컬 개발 서버 연결
- 디버그 모드 활성화
- 개발용 API 키 사용

### 프로덕션 환경 (.env.product)

- 실제 서버 연결
- 릴리즈 최적화
- 프로덕션 API 키 사용

### 환경변수 전환

```bash
# 개발 환경
flutter run --dart-define-from-file=.env.development

# 프로덕션 환경
flutter run --dart-define-from-file=.env.product
```

## 개발 가이드

### 코드 스타일

- Dart의 공식 스타일 가이드 준수
- `flutter analyze` 통과 필수
- 린팅 규칙: `analysis_options.yaml` 참조

### 상태 관리 패턴

```dart
// Provider 기반 상태 관리 예시
class AccommodationProvider with ChangeNotifier {
  List<Accommodation> _accommodations = [];

  Future<void> fetchAccommodations() async {
    try {
      _accommodations = await _service.getAccommodations();
      notifyListeners();
    } catch (e) {
      // 에러 처리
    }
  }
}
```

### API 호출 예시

```dart
// Dio를 사용한 API 호출
class AccommodationApiService {
  final Dio _dio;

  Future<List<AccommodationModel>> getAccommodations({
    required String region,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final response = await _dio.get(
      ApiPaths.accommodations,
      queryParameters: {
        'region': region,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
      },
    );

    return (response.data as List)
        .map((json) => AccommodationModel.fromJson(json))
        .toList();
  }
}
```

### 새 기능 추가하기

1. **Feature 디렉토리 생성**

```
lib/features/new_feature/
├── data/
│   ├── datasources/
│   └── models/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

2. **데이터 모델 작성**

```dart
// models/new_model.dart
@JsonSerializable()
class NewModel {
  final int id;
  final String name;

  NewModel({required this.id, required this.name});

  factory NewModel.fromJson(Map<String, dynamic> json) =>
      _$NewModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewModelToJson(this);
}
```

3. **코드 생성 실행**

```bash
flutter pub run build_runner build
```

4. **Provider 작성**

```dart
// providers/new_provider.dart
class NewProvider with ChangeNotifier {
  // 상태 및 비즈니스 로직
}
```

5. **화면 작성**

```dart
// screens/new_screen.dart
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            appBar: AppBar(title: Text('New Feature')),
            body: // UI 구현
        );
      },
    );
  }
}
```

6. **라우트 추가**

```dart
// core/router/app_router.dart
GoRoute
(
path: RoutePaths.newFeature,
builder: (context, state
)
=>
NewScreen
(
)
,
)
```

## 빌드 및 배포

### Android 빌드

**APK 빌드**

```bash
flutter build apk --release
```

**AAB 빌드 (Google Play Store)**

```bash
flutter build appbundle --release
```

### iOS 빌드

```bash
flutter build ios --release
```

### Web 빌드

```bash
flutter build web --release
```

### 빌드 산출물 위치

- Android APK: `build/app/outputs/flutter-apk/`
- Android AAB: `build/app/outputs/bundle/release/`
- iOS: `build/ios/archive/`
- Web: `build/web/`

## 테스트

### 단위 테스트

```bash
flutter test
```

### 위젯 테스트

```bash
flutter test test/widget_test.dart
```

### 통합 테스트

```bash
flutter test integration_test/
```

## 트러블슈팅

### 일반적인 문제 해결

**1. 패키지 의존성 오류**

```bash
flutter clean
flutter pub get
```

**2. 코드 생성 오류**

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**3. iOS 빌드 오류**

```bash
cd ios
pod install
cd ..
flutter clean
flutter build ios
```

**4. Android 빌드 오류**

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk
```
