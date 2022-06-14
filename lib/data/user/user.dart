import 'dart:convert';

class User {
  final String email;
  final String password;
  final String phoneNumber;

  const User(this.email, this.password, this.phoneNumber);

  static User? fromJson(String json) {
    try {
      dynamic data = jsonDecode(json);
      return User(data["email"], data["password"], data["phoneNumber"]);
    } catch (e) {
      return null;
    }
  }

  Map toJson() => {
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      };

  // factory User.fromJson(String json) {
  //   try {
  //     dynamic data = jsonDecode(json);
  //     return User(data["email"], data["password"], data["phoneNumber"]);
  //   } catch (e) {
  //     return const User("", "", "");
  //   }
  // }

  String asJson() {
    return jsonEncode(this);
  }

  @override
  String toString() {
    return '{ email: $email, password: $password, phone_number: $phoneNumber }';
  }
}
