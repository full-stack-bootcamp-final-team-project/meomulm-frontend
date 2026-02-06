import 'package:flutter/foundation.dart';

class NotificationResponseModel {
  final int notificationId;
  final int userId;
  final String notificationContent;
  final String notificationLinkUrl;
  bool isRead;
  final DateTime createdAt;

  NotificationResponseModel({
    required this.notificationId,
    required this.userId,
    required this.notificationContent,
    required this.notificationLinkUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      notificationId: json['notificationId'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      notificationContent: json['notificationContent'] as String? ?? '',
      notificationLinkUrl: json['notificationLinkUrl'] as String? ?? '',
      isRead: json['read'] as bool? ?? false,
      createdAt: _parseCreatedAt(json['createdAt'] as String?),
    );
  }

  static DateTime _parseCreatedAt(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return DateTime(2000);
    }

    try {
      final parsed = DateTime.parse(raw.trim());

      final utc = DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
        parsed.millisecond,
        parsed.microsecond,
      );

      return utc.toLocal();
    } catch (e) {
      debugPrint('createdAt 파싱 실패: "$raw" → $e');
      return DateTime(2000);
    }
  }

}