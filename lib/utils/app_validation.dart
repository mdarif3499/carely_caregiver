class AppValidation {
  AppValidation._();

  static final emailRegexp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  static String? email(String? value) {
    final error = required(value);
    if (error != null) return error;

    if (!emailRegexp.hasMatch(value!)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? password(String? value) {
    final error = required(value);
    if (error != null) return error;
    if (value!.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final error = required(value);
    if (error != null) return error;

    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
