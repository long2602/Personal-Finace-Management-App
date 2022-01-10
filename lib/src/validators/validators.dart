class isValidator {
  //check email
  static isValidEmail(String email) {
    final regularExpression = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    return regularExpression.hasMatch(email);
  }

  //check password
  static isValidPassword(String password) => password.length >= 8;

  //check confirm password
  static isValidConfirmPassword(String pass, String repass) =>
      (pass == repass && pass.isNotEmpty) ? true : false;

  //check name
  static isValidName(String name) => name.isNotEmpty;
}
