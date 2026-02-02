import 'package:flutter/material.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() =>
      _notification_list_screenState();
}

/*
"예약 완료! [숙소명] 예약이 확정되었습니다."
"[숙소명] 예약이 정상적으로 취소되었습니다."
"내일은 [숙소명] 체크인 날입니다!"
"숙소는 어떠셨나요? 리뷰를 남겨주세요!"
"오직 고객님을 위한 생일 쿠폰이 발급되었습니다."
"문의하신 답변이 등록되었습니다. 바로 확인해보세요."

--- 13. 알림
CREATE TABLE IF NOT EXISTS notification (
notification_id SERIAL PRIMARY KEY,
user_id INT,
content VARCHAR(100),
link_url VARCHAR(500),
is_read BOOLEAN,
created_at TIMESTAMP
);

생일 알림 (매일 오전 9시)
User 테이블에서 오늘이 생일인 사용자를 조회한다.
쿠폰 발급 로직을 실행하면서 개인 알림 전송 후, 알림 테이블에 저장한다.

체크인 전날 안내 (매일 오전 10시)
Reservation 테이블에서 check_in_date가 내일인 데이터를 조회한다.
숙소 체크인 알림 전송 후, 알림 테이블에 저장한다.

리뷰 작성 요청 (매일 오전 11시)
Reservation 테이블에서 check_out_date가 어제인 데이터를 조회한다.
리뷰 작성 페이지 링크와 함꼐 개인 개인 알림 전송 후, 알림 테이블에 저장한다.
 */

class _notification_list_screenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('notification_list_screen is working'),
      ),
    );
  }
}