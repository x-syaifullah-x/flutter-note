import 'dart:convert';

import 'package:submission_bmafup/data/category/category.dart';

class Note {
  static const String _keyId = "id";
  static const String _keyJsonArray = "jsonArray";
  static const String _keyCategory = "category";
  static const String _keyCreatedAt = "createdAt";
  static const String _keyUpdateAt = "updatedAt";

  final int id;
  final String jsonArray;
  final Category category;
  final int createdAt;
  final int updatedAt;

  const Note({
    required this.id,
    required this.jsonArray,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      _keyId: id,
      _keyJsonArray: jsonArray,
      _keyCategory: category,
      _keyCreatedAt: createdAt,
      _keyUpdateAt: updatedAt,
    };
  }

  factory Note.fromJson(String jsonNote) {
    try {
      dynamic dynamicNote = jsonDecode(jsonNote);
      return Note(
        id: dynamicNote[_keyId],
        jsonArray: dynamicNote[_keyJsonArray],
        category: Category(
          dynamicNote[_keyCategory][Category.FIELD_NAME_VALUE],
        ),
        createdAt: dynamicNote[_keyCreatedAt],
        updatedAt: dynamicNote[_keyUpdateAt],
      );
    } catch (e, stacktrace) {
      rethrow;
    }
  }

  @override
  String toString() => jsonEncode(this);

  Note copy({
    int? id,
    String? jsonArray,
    Category? category,
    int? createdAt,
    int? updatedAt,
  }) =>
      Note(
        id: id ?? this.id,
        jsonArray: jsonArray ?? this.jsonArray,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jsonArray == other.jsonArray &&
          category == other.category &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      jsonArray.hashCode ^
      category.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
