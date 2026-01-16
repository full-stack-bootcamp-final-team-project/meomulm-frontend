/// =====================
/// 다이얼로그 상수
/// =====================
class DialogMessages {
  DialogMessages._();

  static const logoutContent = '로그아웃하시겠습니까?';
  static const cancelBookingContent = '예약을 취소하시겠습니까?\n  취소 후에는 다시 되돌릴 수 없습니다.';
  static const discardChangesContent = '저장하지 않은 리뷰가 있습니다.\n정말 나가시겠습니까?';
  static const deleteReview = '리뷰를 삭제하시겠습니까?';
  static const cancelPaymentContent = '결제를 취소하시겠습니까?';
}

/// =====================
/// 스낵바(SnackBar) 상수
/// =====================
class SnackBarMessages {
  SnackBarMessages._();
  
  static const String signupCompleted = '회원가입이 완료되었습니다.';
  static const String loginCompleted = '로그인이 완료되었습니다.';
  static const String passwordChanged = '비밀번호가 변경되었습니다.';

  static const String reviewSubmitted = '리뷰가 등록되었습니다.';
  static const String reviewDeleted = '리뷰가 삭제되었습니다.';

  static const String bookingCompleted = '예약이 완료되었습니다.';
  static const String bookingCanceled = '예약이 취소되었습니다.';
}

/// =====================
/// 조회 결과 없는 경우 상수
/// =====================
class EmptyMessages {
  EmptyMessages._();

  static const String myReviews = '작성한 리뷰가 없습니다.';
  static const String accommodationReviews = '아직 등록된 리뷰가 없습니다.';
  static const String bookingHistory = '예약 내역이 없습니다.';
  static const String accommodations = '숙소가 없습니다.';
  static const String searchResult = '검색 결과가 없습니다.';
  static const String rooms = '객실이 없습니다.';
  static const String favorites = '찜한 숙소가 없습니다.';
}

/// =====================
/// 진행 상태 상수
/// =====================
class StatusMessages {
  StatusMessages._();

  static const String loadingAccommodations = '숙소를 불러오는 중입니다...';
  static const String loadingRooms = '객실 정보를 불러오는 중입니다...';
  static const String loadingReviews = '리뷰를 불러오는 중입니다...';
  static const String processingBooking = '예약을 진행 중입니다...';
  static const String processingPayment = '결제를 처리 중입니다...';
}
