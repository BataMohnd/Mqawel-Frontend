class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'برجاء إدخال رقم الهاتف';
    }
    if (value.length < 10) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال $fieldName';
    }
    return null;
  }
}
