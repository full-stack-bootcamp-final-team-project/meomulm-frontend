import 'package:intl/intl.dart';

extension PriceFormatter on int {
  String formatPrice() {
    return NumberFormat('#,###').format(this);
  }

  String formatPriceWon() {
    return '${formatPrice()}원';
  }
}
