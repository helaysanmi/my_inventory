class TValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validateInviteCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invite code is required.';
    }

    // Check for  invite code length
    if (value.length < 8 || value.length > 8) {
      return 'Invite code must be 8 characters long.';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    return null;
  }

  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }

    return null;
  }

  static String? validateProductQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product quantity is required';
    }

    return null;
  }

  static String? validateProductAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product amount is required';
    }

    final trimmed = value.trim();

    final doubleAmount = double.tryParse(trimmed);
    if (doubleAmount == null) {
      return 'Enter a valid product amount';
    }

    if (doubleAmount <= 0) {
      return 'Product amount must be greater than zero';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    if (value.length < 10 || value.length > 10) {
      return 'Phone number should be 10 digit.';
    }

    return null;
  }
}
