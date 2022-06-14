import 'dart:convert';

class Category {
  const Category(this._value);

  // ignore: constant_identifier_names
  static const String ALL = "ALL";

  // ignore: constant_identifier_names
  static const String FIELD_NAME_VALUE = "_value";

  factory Category.all() {
    return const Category(ALL);
  }

  final String? _value;

  String get value => (_value ?? ALL).toUpperCase();

  Map<String, dynamic> toJson() => {
        FIELD_NAME_VALUE: value,
      };

  factory Category.fromJson(String jsonCategory) {
    try {
      dynamic dynamicNote = jsonDecode(jsonCategory); // called toJson()
      return Category(
        dynamicNote[FIELD_NAME_VALUE],
      );
    } catch (e, stacktrace) {
      rethrow;
    }
  }

  @override
  String toString() => jsonEncode(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
