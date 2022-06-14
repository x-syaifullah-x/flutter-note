import 'package:submission_bmafup/data/category/category.dart';
import 'package:submission_bmafup/data/category/category_local_data_source.dart';
import 'package:submission_bmafup/data/listener.dart';
import 'package:submission_bmafup/data/user/user.dart';

class CategoryRepository extends Listener<Category> {
  CategoryRepository._(this._localDataSource);

  static CategoryRepository? _instance;

  static CategoryRepository getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = CategoryRepository._(CategoryLocalDataSource.getInstance());
      return _instance!;
    }
  }

  final CategoryLocalDataSource _localDataSource;

  Future<List<Category>> getCategories(User user) async {
    List<String>? categories = await _localDataSource.getCategories(user);
    if (categories.isEmpty) {
      await _localDataSource.add(user, Category.ALL);
    }
    await Future.delayed(const Duration(seconds: 1));
    List<String> result = await _localDataSource.getCategories(user);
    return result.map((e) => Category(e)).toList();
  }

  Future<bool> delete(User user, Category category) async {
    String? result = await _localDataSource.delete(user, category.value);
    if (result != null) {
      onChange(ListenerType.delete, Category(result));
      return true;
    }
    return false;
  }

  Future<bool> add(User user, Category category) async {
    String? result = await _localDataSource.add(user, category.value);
    if (result != null) {
      onChange(ListenerType.add, Category(result));
      return true;
    }
    return false;
  }
}
