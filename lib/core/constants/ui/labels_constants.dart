/// =====================
/// 버튼 텍스트 상수
/// =====================
class ButtonLabels {
  ButtonLabels._();

  static const String login = '로그인';
  static const String signUp = '회원가입';
  static const String findId = '아이디 찾기';
  static const String changePassword = '비밀번호 변경';

  static const String confirm = '확인';
  static const String edit = '수정하기';
  static const String apply = '변경하기';
  static const String register = '등록';
  static const String search = '검색';
  static const String backToHome = '메인으로 돌아가기';

  static const String bookNow = '예약하기';
  static const String changeBooking = '예약 변경';
  static const String cancelBooking = '예약 취소';
  static const String bookingConfirm = '예약 확인';

  static const String viewAllRooms = '모든 객실 보기';

  static const String writeReview = '리뷰 입력';

  static String payWithPrice(int price) => '$price원 결제하기';
}

/// =====================
/// 필터 상수
/// =====================
class FilterLabels {
  FilterLabels._();

  static const String basic = '편의시설';
  static const String priceRange = '가격 범위';
  static const String ratingRange = '평점';
  static const String category = '숙소 종류';
}

/// =====================
/// 정렬 상수
/// =====================
class SortLabels {
  SortLabels._();

  static const String basic = '기본순';
  static const String price = '가격순';
  static const String rating = '평점순';
}

/// =====================
/// 타이틀 상수
/// =====================
class TitleLabels {
  TitleLabels._();

  static const String signUp = '회원가입';
  static const String editProfile = '회원정보 수정';
  static const String mypageChangePassword = '비밀번호 수정'; 
  static const String findId = '아이디 찾기';
  static const String verifyIdentity = '본인 확인';
  static const String loginChangePassword = '비밀번호 변경';

  static const String myInfo = '내 정보';
  static const String wishlist = '찜 목록';
  static const String myBookings = '예약 내역';
  static const String myReviews = '내 리뷰';

  static const String writeReview = '리뷰 작성';
  static const String reviews = '리뷰';

  static const String searchAccommodation = '숙소 검색';
  static const String booking = '예약하기';
  static const String payment = '결제하기';
  static const String selectRegion = '지역 선택';
  
  static const String chat = '머묾 챗봇';

  static String accommodationName(String name) => name;
}
