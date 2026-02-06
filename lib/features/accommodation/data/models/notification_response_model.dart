import 'accommodation_image_model.dart';

class NotificationResponseModel {
  final int notificationId;
  final int userId;
  final String notificationContent;
  final String notificationLinkUrl;
  bool isRead;
  final String createdAt;

  NotificationResponseModel({
    required this.notificationId,
    required this.userId,
    required this.notificationContent,
    required this.notificationLinkUrl,
    required this.isRead,
    required this.createdAt
  });


  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationResponseModel(
        notificationId: json['notificationId'] as int? ?? 0,
        userId: json['userId'] as int? ?? 0,
        notificationContent: json['notificationContent'] as String? ?? '',
        notificationLinkUrl: json['notificationLinkUrl'] as String? ?? '',
        isRead: json['isRead'] as bool? ?? false,
        createdAt: json['createdAt'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      print('Notification.fromJson 실패: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'notificationContent': notificationContent,
      'notificationLinkUrl': notificationLinkUrl,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}