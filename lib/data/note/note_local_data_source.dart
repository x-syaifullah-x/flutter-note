import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_bmafup/data/user/user.dart';

class NoteLocalDataSource {
  NoteLocalDataSource._(this._prefs);

  static NoteLocalDataSource? _instance;

  static NoteLocalDataSource getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = NoteLocalDataSource._(SharedPreferences.getInstance());
      return _instance!;
    }
  }

  final Future<SharedPreferences> _prefs;

  String _getKey(User user) => "NOTE-$user";

  Future<List<String>> getNoteAsJsonArray(User user) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_getKey(user)) ?? [];
  }

  Future<bool> save(User user, List<String> jsonArrayNote) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setStringList(_getKey(user), jsonArrayNote);
  }
}
