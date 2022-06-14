import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../data/note/note.dart';
import '../../data/note/note_repository.dart';
import '../../data/user/user.dart';
import '../edit/edit_screen.dart';

class TabBarViewContent extends StatelessWidget {
  const TabBarViewContent(
    this._user,
    this.notes, {
    Key? key,
  }) : super(key: key);

  final User _user;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        Note note = notes[(notes.length - 1) - index];

        return _TabBarViewContentItem(
          mt: (index == 0 || index == 1) ? 6 : 3,
          text: _convertNoteJsonArrayToString(note.jsonArray),
          date: _timeMillisecondsToDate(note.updatedAt),
          iconPreviewOnPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => EditScreen(
                  user: _user,
                  noteId: note.id,
                  category: note.category,
                  readOnly: true,
                ),
              ),
            );
          },
          iconEditOnPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => EditScreen(
                  user: _user,
                  noteId: note.id,
                  category: note.category,
                  readOnly: false,
                ),
              ),
            );
          },
          iconDeleteOnPressed: () {
            NoteRepository.getInstance().delete(_user, note.id);
          },
        );
      },
    );
  }

  String _timeMillisecondsToDate(int milliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return "$dateTime".replaceAll(RegExp(r'[.]\w+'), "");
  }

  String _convertNoteJsonArrayToString(String noteJsonArray) {
    List<dynamic> data = jsonDecode(noteJsonArray);
    flutter_quill.Document document = flutter_quill.Document.fromJson(data);
    String text = document.toPlainText().replaceAll("\n", " ");
    int maxChar = 300;
    String result = text;
    if (text.length > maxChar) {
      result = text.replaceRange(maxChar, text.length, " ...");
    }
    return result;
  }
}

class _TabBarViewContentItem extends StatelessWidget {
  const _TabBarViewContentItem({
    Key? key,
    this.mt = 3,
    // ignore: unused_element
    this.mb = 3,
    // ignore: unused_element
    this.mr = 3,
    // ignore: unused_element
    this.ml = 3,
    required this.text,
    required this.date,
    this.iconDeleteOnPressed,
    this.iconEditOnPressed,
    this.iconPreviewOnPressed,
  }) : super(key: key);

  final double mt;
  final double mb;
  final double ml;
  final double mr;
  final String text;
  final String date;
  final VoidCallback? iconDeleteOnPressed;
  final VoidCallback? iconEditOnPressed;
  final VoidCallback? iconPreviewOnPressed;

  @override
  Widget build(BuildContext context) {
    Widget dateView = Container(
      margin: const EdgeInsets.only(
        right: 16,
        bottom: 10,
        top: 10,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(date),
      ),
    );
    Widget dividerView = Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
    );
    return Container(
      margin: EdgeInsets.only(
        top: mt,
        left: ml,
        right: mr,
        bottom: mb,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(minHeight: 85),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(text),
            ),
          ),
          dateView,
          dividerView,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: iconPreviewOnPressed,
                icon: const Icon(Icons.preview),
              ),
              IconButton(
                onPressed: iconEditOnPressed,
                icon: const Icon(Icons.edit_note),
              ),
              IconButton(
                onPressed: iconDeleteOnPressed,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
