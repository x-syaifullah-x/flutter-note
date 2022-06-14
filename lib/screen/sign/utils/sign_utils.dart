import 'package:submission_bmafup/utils/utils.dart';

String? emailValidate(String email) {
  if (email.isEmpty) {
    return "Please input email address";
  } else if (!isEmail(email)) {
    return "Please input correct email";
  }
  return null;
}

String? passwordValidate(String password) {
  if (password.isEmpty) {
    return "Please input password";
  } else if (password.length < 6) {
    return "Password must have 6 characters or more";
  }
  return null;
}
