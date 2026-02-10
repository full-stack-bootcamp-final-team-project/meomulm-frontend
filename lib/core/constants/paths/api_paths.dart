import '../config/env_config.dart';

/// =====================
/// API 경로
/// =====================
class ApiPaths {
  ApiPaths._();

  // 기본 url
  static final String baseUrl = EnvConfig.apiBaseUrl;
  static final String authUrl = '$baseUrl/auth';
  static final String accommodationUrl = '$baseUrl/accommodation';

  // 키워드로 숙소 조회
  static final String accommodationKeywordUrl = '$accommodationUrl/keyword';
  // 지역별 가격 낮은 숙소 12개 조회
  static final String accommodationPopularUrl = '$accommodationUrl/popular';
  // 현재위치 기반 반경 5km 내 숙소 조회 : 지도 검색
  static final String accommodationMapUrl = '$accommodationUrl/map';
  // 숙소 ID 로 숙소 상세정보 조회
  static final String accommodationDetailUrl = '$accommodationUrl/detail';

  // 찜목록 가져오기 / 찜 추가하기 / 찜 삭제하기
  static final String favoriteUrl = '$baseUrl/favorite';

  // 결제 정보 추가
  static final String paymentUrl = '$baseUrl/payment';

  // 객실 검색
  static final String productUrl = '$baseUrl/product/search';

  // 예약 추가 / 예약 수정 / 예약 취소
  static final String reservationUrl = '$baseUrl/reservation';

  // 리뷰 작성 / 리뷰 삭제
  static final String reviewUrl = '$baseUrl/review';
  // 숙소별 리뷰 조회
  static final String accommodationReviewUrl = '$reviewUrl/accommodationId';
  // 내 리뷰 조회
  static final String myReviewUrl = '$reviewUrl/userId';

  // 회원가입
  static final String signupUrl = '$authUrl/signup';
  // 로그인
  static final String loginUrl = '$authUrl/login';
  // 아이디 찾기
  static final String findIdUrl = '$authUrl/findId';
  // 본인 인증(로그인)
  static final String confirmPasswordUrl = '$authUrl/checkPassword';
  // 비밀번호 변경(로그인)
  static final String loginChangePasswordUrl = '$authUrl/changePassword';
  // 카카오 생각해보기

  // 회원 알림 조회
  static final String notificationUrl = '$baseUrl/notification';
  // 회원정보 조회
  static final String userUrl = '$baseUrl/users';
  // 회원정보 수정
  static final String userInfoUrl = '$userUrl/userInfo';
  // 회원 예약 내역 조회
  static final String myReservationUrl = '$userUrl/reservation';
  // 프로필 이미지 변경
  static final String profileImageUrl = '$userUrl/profileImage';
  // 비밀번호 확인
  static final String currentPasswordUrl = '$userUrl/currentPassword';
  // 비밀번호 변경(마이페이지)
  static final String changePasswordUrl = '$userUrl/password';

  // 챗봇
  static final String chatUrl = '$baseUrl/chat';
}
