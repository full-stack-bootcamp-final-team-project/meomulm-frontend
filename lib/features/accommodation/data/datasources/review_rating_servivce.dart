import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

class RatingHelper {
  static double calculateRating(dynamic ratingInput) {
    if (ratingInput == null) return 0.0;
    double rating = 0.0;
    if (ratingInput is num) {
      rating = ratingInput.toDouble();
    } else if (ratingInput is String) {
      rating = double.tryParse(ratingInput) ?? 0.0;
    }
    return rating / 2;
  }

  static double halfFloorRating(dynamic ratingInput) {
    double score = calculateRating(ratingInput);
    return (score - score.floor() >= 0.1) ? score.floor() + 0.5 : score.floorToDouble();
  }

  static List<Widget> buildStarIcons(String ratingStr, {double size = 16.0}) {
    double score = calculateRating(ratingStr);
    return List.generate(5, (index) {
      if (index < score.floor()) {
        return Icon(AppIcons.star, color: AppColors.ratingColor, size: size);
      } else if (index < score) {
        return Icon(Icons.star_half, color: AppColors.ratingColor, size: size);
      } else {
        return Icon(Icons.star_outline, color: AppColors.gray2, size: size);
      }
    });
  }
}