/// =====================
/// 다이얼로그 상수
/// =====================
class DialogMessages {
  DialogMessages._();

  static const logoutContent = '로그아웃하시겠습니까?';
  static const cancelBookingContent = '예약을 취소하시겠습니까?\n취소 후에는 다시 되돌릴 수 없습니다.';
  static const discardChangesContent = '저장하지 않은 리뷰가 있습니다.\n정말 나가시겠습니까?';
  static const deleteReview = '리뷰를 삭제하시겠습니까?';
  static const cancelPaymentContent = '결제를 취소하시겠습니까?';
}

/// =====================
/// 입력창 메세지 상수
/// =====================
class InputMessages {
  InputMessages._();

  // 이메일
  static const invalidEmail = '유효하지 않은 이메일 형식입니다.';
  static const emptyEmail = '이메일은 필수 입력 사항입니다.';
  static const duplicateEmail = '이미 존재하는 이메일입니다.';
  static const validEmail = "사용 가능한 이메일입니다.";

  // 비밀번호
  static const invalidPassword = '8~16자의 영문 대소문자, 숫자, 특수문자만 가능합니다.';
  static const validPassword = "사용 가능한 비밀번호입니다.";
  static const mismatchPassword = '비밀번호가 일치하지 않습니다.';
  static const matchPassword = '비밀번호가 일치합니다.';
  static const emptyPassword = '비밀번호를 입력하세요.';

  // 이름
  static const invalidName = '이름은 영어와 한글만 입력 가능합니다.';
  static const emptyName = '이름은 필수 입력 사항입니다.';
  static const validName = "사용 가능한 이름입니다.";
  static const nameLength = "이름은 2글자 이상이여야 합니다.";

  // 연락처
  static const invalidPhone = '연락처는 숫자 또는 하이픈만 입력 가능합니다.';
  static const emptyPhone = '연락처는 필수 입력 사항입니다.';
  static const duplicatePhone = '이미 존재하는 연락처입니다.';
  static const validPhone = "사용 가능한 전화번호입니다.";
  static const minLengthPhone = '전화번호는 최소 10자리 이상이어야 합니다.';
  static const maxLengthPhone = '전화번호는 14자리 미만이여야 합니다.';

  // 생년월일
  static const emptyBirth = '생년월일은 필수 입력 사항입니다.';
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
  static const String recentAccommodationsEmpty  = '최근 본 숙소가 없습니다.';
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
/// =====================
/// 위치 권한/서비스 메세지 상수
/// =====================
class LocationMessages {
  LocationMessages._();

  // 타이틀
  static const String serviceDisabledTitle = '위치 서비스가 비활성화되어 있습니다';
  static const String permissionDeniedTitle = '위치 권한이 필요합니다';
  static const String permissionDeniedForeverTitle = '위치 권한이 거부되었습니다';
  static const String timeoutTitle = '위치를 가져올 수 없습니다';
  static const String unknownTitle = '위치 정보 오류';

  // 메시지
  static const String serviceDisabledMessage = '기기의 위치 서비스를 켜주세요.';
  static const String permissionDeniedMessage = '주변 숙소를 찾기 위해 위치 권한이 필요합니다.';
  static const String permissionDeniedForeverMessage = '설정에서 위치 권한을 허용해주세요.';
  static const String timeoutMessage = '위치 정보를 가져오는데 시간이 초과되었습니다.';
  static const String unknownMessage = '위치 정보를 가져오는데 문제가 발생했습니다.';

  // 버튼
  static const String retryButton = '다시 시도';
}