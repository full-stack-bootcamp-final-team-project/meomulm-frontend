/// =====================
/// 스크린 라우팅 경로
/// =====================
class RoutePaths{
  RoutePaths._();

  /// =====================
  /// intro 라우팅 경로
  /// =====================
  // 로딩 스크린(intro_screen)
  static const String intro = '/intro';
  // 메인 스크린(home_screen)
  static const String home ='/home';

  /// =====================
  /// auth 라우팅 경로
  /// =====================
  // 로그인 스크린 (login_screen)
  static const String login ='/login';
  // 아이디 찾기 스크린 (find_id_screen)
  static const String findId = '/find-id';
  // 회원가입 스크린 (signup_screen)
  static const String signup = '/signup';
  // 본인 인증 스크린 (confirm_password_screen)
  static const String confirmPassword = '/confirm-password';
  // 비밀번호 변경 스크린 (로그인) (login_change_password_screen)
  static const String loginChangePassword = '/login-change-password';

  /// =====================
  /// accommodation 라우팅 경로
  /// =====================
  // 알림 목록 스크린 (notification_list_screen)
  static const String notificationList = '/notification-list';
  // 숙소 검색 스크린 (search_accommodation_screen)
  static const String accommodationSearch = '/accommodation-search';
  // 숙소 필터 스크린 (accommodation_filter_screen)
  static const String accommodationFilter = '/accommodation-filter';
  // 숙소 결과 스크린 (accommodation_list_screen)
  static const String accommodationResult = '/accommodation-result';
  // 숙소 리뷰 스크린 (accommodation_review_screen)
  static const String accommodationReview = '/accommodation-review';
  // 숙소 상세 스크린 (accommodation_detail_screen)
  static const String accommodationDetail = '/accommodation-detail';
  // 객실 목록 스크린(product_list_screen)
  static const String productList = '/product-list';

  /// =====================
  /// map 라우팅 경로
  /// =====================

// 지도 메인 스크린
  static const String map = '/map';

// 지도 검색 필터 스크린
  static const String mapSearch = '/map-search';

// 지도 검색 지역 선택 스크린
  static const String mapSearchRegion = '/map-search/region';

// 지도 검색 결과 스크린
  static const String mapSearchResult = '/map-search/result';


  /// =====================
  /// mypage 라우팅 경로
  /// =====================
  // 마이페이지 스크린 (mypage_screen)
  static const String myPage = '/mypage';
  // 프로필 수정 스크린 (edit_profile_screen)
  static const String editProfile = '/edit-profile';
  // 예약 내역 스크린 (my_reservations_screen)
  static const String myReservation = '/reservation';
  // 회원 리뷰 조회 스크린 (my_review_screen)
  static const String myReview = '/review';
  // 회원 리뷰 작성 스크린(my_review_write_screen)
  static const String myReviewWrite = '/review-write';
  // 비밀번호 변경 스크린 (마이페이지) (mypage_change_password_screen)
  static const String myPageChangePassword = '/change-password';
  // 찜하기 스크린(favorite_screen)
  static const String favorite = '/favorite';

  /// =====================
  /// reservation 라우팅 경로
  /// =====================
  // 결제 스크린 (payment_screen)
  static const String payment = '/payment';
  // 예약 스크린 (reservation_screen)
  static const String reservation = '/reservation';
  // 결제 완료 스크린 (payment_success_screen)
  static const String paymentSuccess = '/payment-success';

  /// =====================
  /// chatbot 라우팅 경로
  /// =====================
  // 챗봇 스크린 (chat_screen)
  static const String chat = '/chat';
}