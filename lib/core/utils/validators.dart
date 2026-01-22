class Validators {
  Validators._();

  /// =======================
  /// REQUIRED
  /// =======================
  static String? required(String? value, {String fieldName = 'Trường này'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  /// =======================
  /// EMAIL
  /// =======================
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// =======================
  /// PASSWORD
  /// =======================
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < minLength) {
      return 'Mật khẩu tối thiểu $minLength ký tự';
    }

    return null;
  }

  /// =======================
  /// CONFIRM PASSWORD
  /// =======================
  static String? confirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }

    if (value != originalPassword) {
      return 'Mật khẩu không khớp';
    }

    return null;
  }

  /// =======================
  /// PHONE NUMBER (VN)
  /// =======================
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    }

    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }

    return null;
  }

  /// =======================
  /// NUMBER ONLY
  /// =======================
  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống';
    }

    if (int.tryParse(value) == null) {
      return 'Chỉ được nhập số';
    }

    return null;
  }

  /// =======================
  /// MIN LENGTH
  /// =======================
  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Tối thiểu $min ký tự';
    }
    return null;
  }
}
