import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_response_model.dart';
/// ===============================
/// 리뷰 관련 상태관리
/// ===============================
class ReviewProvider with ChangeNotifier {
  final List<ReviewResponseModel> _reviews = [];
  List<ReviewResponseModel> get reviews => _reviews;

  void setReviews(List<ReviewResponseModel> items) {
    _reviews
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void removeReview(int reviewId) {
    _reviews.removeWhere((r) => r.reviewId == reviewId);
    notifyListeners();
  }
}