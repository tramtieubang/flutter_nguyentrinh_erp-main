import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// =======================
  /// INPUT FORMATTERS
  /// =======================

  /// Chỉ cho nhập số
  static List<TextInputFormatter> numberOnly() {
    return [
      FilteringTextInputFormatter.digitsOnly,
    ];
  }

  /// Số + dấu chấm (tiền)
  static List<TextInputFormatter> currencyInput() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ];
  }

  /// Số điện thoại (VN)
  static List<TextInputFormatter> phone() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ];
  }

  /// =======================
  /// FORMAT HIỂN THỊ
  /// =======================

  /// Định dạng tiền VN
  static String currency(num value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(value);
  }

  /// Định dạng ngày: dd/MM/yyyy
  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Định dạng ngày giờ
  static String dateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// =======================
  /// TEXT
  /// =======================

  /// Viết hoa chữ cái đầu
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Ẩn email
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    if (name.length <= 2) return email;

    return '${name.substring(0, 2)}***@${parts[1]}';
  }
}
