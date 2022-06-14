import 'dart:convert';

import 'package:submission_bmafup/data/category/category.dart';
import 'package:submission_bmafup/data/listener.dart';
import 'package:submission_bmafup/data/note/note.dart';
import 'package:submission_bmafup/data/note/note_local_data_source.dart';
import 'package:submission_bmafup/data/user/user.dart';

class NoteRepository extends Listener<Note> {
  NoteRepository._(this._localDataSource);

  static NoteRepository? _instance;

  static NoteRepository getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = NoteRepository._(NoteLocalDataSource.getInstance());
      return _instance!;
    }
  }

  final NoteLocalDataSource _localDataSource;

  Future<List<Note>> getNotes(User user) async {
    final List<String> noteAsJsonArray =
    await _localDataSource.getNoteAsJsonArray(user);
    await Future.delayed(const Duration(seconds: 2));
    return noteAsJsonArray.map((jsonNote) => Note.fromJson(jsonNote)).toList();
  }

  Future<Note?> getNote(User user, int? noteId) async {
    Note? result;
    if (noteId != null) {
      final List<String> noteAsJsonArray =
          await _localDataSource.getNoteAsJsonArray(user);
      for (var jsonNote in noteAsJsonArray) {
        if (jsonNote.contains("$noteId")) {
          result = Note.fromJson(jsonNote);
          break;
        }
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    return result;
  }

  Future<int> update(
    User user,
    int noteId,
    String? data,
    Category? category,
  ) async {
    List<String> jsonArrayNotes =
        await _localDataSource.getNoteAsJsonArray(user);

    int result = 0;
    for (var i = 0; i < jsonArrayNotes.length; i++) {
      Note noteOld = Note.fromJson(jsonArrayNotes[i]);
      if (noteOld.id == noteId) {
        if (noteOld.jsonArray != data || noteOld.category.value != category?.value) {
          Note newNote = noteOld.copy(
            jsonArray: data,
            category: category,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );
          jsonArrayNotes.removeAt(i);
          jsonArrayNotes.add(jsonEncode(newNote));
          bool isSaved = await _localDataSource.save(user, jsonArrayNotes);
          if (isSaved) {
            result = noteOld.id;
            onChange(ListenerType.update, newNote);
          }
        }
      }
    }
    return result;
  }

  Future<int> save(User user, String jsonArrayNote, Category category) async {
    List<String> jsonArrayNotes =
        await _localDataSource.getNoteAsJsonArray(user);
    final dateTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;
    Note note = Note(
      id: dateTimeMilliseconds,
      jsonArray: jsonArrayNote,
      category: category,
      createdAt: dateTimeMilliseconds,
      updatedAt: dateTimeMilliseconds,
    );

    jsonArrayNotes.add(jsonEncode(note));
    bool isSuccessSave = await _localDataSource.save(user, jsonArrayNotes);
    int result = 0;
    if (isSuccessSave) {
      result = note.id;
      onChange(ListenerType.add, note);
    }
    return result;
  }

  Future<bool> delete(User user, int? noteId) async {
    List<String> currentData = await _localDataSource.getNoteAsJsonArray(user);
    bool isDeleted = false;
    for (var index = 0; index < currentData.length; index++) {
      Note note = Note.fromJson(currentData[index]);
      if (note.id == noteId) {
        currentData.removeAt(index);
        isDeleted = await _localDataSource.save(user, currentData);
        if (isDeleted) {
          onChange(ListenerType.delete, note);
        }
      }
    }
    return isDeleted;
  }
}
