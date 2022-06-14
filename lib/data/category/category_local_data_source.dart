import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_bmafup/data/user/user.dart';

class CategoryLocalDataSource {
  CategoryLocalDataSource._(this._prefs);

  static CategoryLocalDataSource? _instance;

  static CategoryLocalDataSource getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = CategoryLocalDataSource._(SharedPreferences.getInstance());
      return _instance!;
    }
  }

  final Future<SharedPreferences> _prefs;

  Future<List<String>> getCategories(User user) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_generateKey(user)) ?? [];
  }

  Future<String?> add(User user, String category) async {
    String? result;
    if (category.isNotEmpty) {
      List<String> dataCategories = await getCategories(user);
      dataCategories.add(category);
      SharedPreferences prefs = await _prefs;
      bool isSave =
          await prefs.setStringList(_generateKey(user), dataCategories);
      if (isSave) {
        result = category;
      }
    }
    return result;
  }

  Future<String?> delete(User user, String category) async {
    String? result;
    if (category.isNotEmpty) {
      List<String> categories = await getCategories(user);
      if (categories.remove(category)) {
        SharedPreferences prefs = await _prefs;
        bool isSave = await prefs.setStringList(_generateKey(user), categories);
        if (isSave) result = category;
      }
    }
    return result;
  }

  String _generateKey(User user) => "CATEGORY-$user";
}
