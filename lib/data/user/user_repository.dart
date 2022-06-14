import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_bmafup/data/user/user.dart';

class UserRepository {
  UserRepository._(this._prefs);

  static UserRepository? _instance;

  static UserRepository getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = UserRepository._(SharedPreferences.getInstance());
      return _instance!;
    }
  }

  final Future<SharedPreferences> _prefs;
  final _currentUserKey = "current_user";

  Future<User?> getCurrentUser() async {
    final json = (await _prefs).getString(_currentUserKey) ?? "";
    return User.fromJson(json);
  }

  Future<User> signup(User user) async {
    User? result = await _saveData(user);
    return (await _setCurrentUser(result));
  }

  Future<User> signIn({
    required String email,
    required String password,
    bool isRemember = false,
  }) async {
    SharedPreferences prefs = await _prefs;
    String? userJson = prefs.getString(_getUserKey(email, password));
    if (userJson != null) {
      User? user = User.fromJson(userJson);
      if (isRemember) {
        return (await _setCurrentUser(user));
      }
      if (user != null) {
        return user;
      } else {
        return Future.error("Error");
      }
    } else {
      return Future.error("Invalid login or password");
    }
  }

  Future<bool> signOut() async => (await _prefs).remove(_currentUserKey);

  Future<bool> _isExist(User user) async =>
      (await _prefs).containsKey(_getUserKey(user.email, user.password));

  String _getUserKey(String email, String password) => "USER-$email$password";

  Future<User?> _saveData(User user) async {
    try {
      if (await _isExist(user)) {
        return Future.error("Email has been used. Try with another email");
      }

      String userKey = _getUserKey(user.email, user.password);
      SharedPreferences prefs = await _prefs;
      bool isSave = await prefs.setString(userKey, user.asJson());
      if (isSave) {
        String result = prefs.getString(userKey)!;
        return User.fromJson(result);
      }
      return Future.error("Invalid save data user");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> _setCurrentUser(User? user) async {
    if (user != null) {
      bool isSet =
          await (await _prefs).setString(_currentUserKey, user.asJson());
      if (isSet) {
        return await getCurrentUser() ?? await Future.error("Error");
      }
    }
    return Future.error("parameter user is null");
  }
}
