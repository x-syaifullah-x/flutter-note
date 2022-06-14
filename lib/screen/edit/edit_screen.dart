import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:submission_bmafup/data/category/category.dart';
import 'package:submission_bmafup/data/category/category_repository.dart';
import 'package:submission_bmafup/data/note/note.dart';
import 'package:submission_bmafup/data/user/user.dart';

import '../../data/listener.dart';
import '../../data/note/note_repository.dart';
import '../home/home_screen_dialog_input_name.dart';
import 'edit_screen_dropdown_category.dart';
import 'edit_screen_placeholder.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    Key? key,
    required this.user,
    this.noteId,
    this.category,
    this.readOnly = false,
  }) : super(key: key);

  final User user;
  final int? noteId;
  final Category? category;
  final bool readOnly;

  @override
  State<StatefulWidget> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late User _user;

  final List<Category> _categories = [Category.all()];
  final NoteRepository _noteRepo = NoteRepository.getInstance();
  final CategoryRepository _categoryRepo = CategoryRepository.getInstance();
  final String key = "Editor";
  final FocusNode _focusNodeEditorBody = FocusNode();

  bool _readOnly = true;

  String _categorySelected = Category.ALL;

  flutter_quill.QuillController? _quillController;

  int? _noteId;

  @override
  void initState() {
    super.initState();

    _noteId = widget.noteId;
    _user = widget.user;
    _readOnly = widget.readOnly;
    _categorySelected =
        widget.category?.value ?? Category.ALL;

    _categoryRepo.setOnChangeListener(key, _onCategoryChange);
    _categoryRepo.getCategories(_user).then((categories) {
      _categories.clear();
      _categories.addAll(categories);
      _noteRepo.getNote(_user, _noteId).then((note) {
        setState(() {
          _categorySelected = note?.category.value ?? _categorySelected;
          _initialiseQuillController(note);
        });
      }).catchError(_handleLoadDataError);
    }).catchError(_handleLoadDataError);
  }

  @override
  Widget build(BuildContext context) {
    final flutter_quill.QuillController? qc = _quillController;

    Widget view;

    if (qc != null) {
      Widget categoryView = DropDownCategory(
        _categorySelected,
        _categories.map((e) => e.value).toList(),
        onSelected: (e) {
          if (e != "ADD") {
            setState(() {
              _categorySelected = e;
            });
          } else {
            showDialog(
              context: context,
              builder: (builder) => HomeScreenDialogInputName(widget.user),
              barrierDismissible: false,
            );
          }
        },
      );
      Widget buttonEdit = IconButton(
        onPressed: () {
          setState(() {
            _readOnly = false;
            _focusNodeEditorBody.requestFocus();
          });
        },
        icon: const Icon(Icons.edit_note),
      );
      Widget editorAppBar = SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (_noteId == null) return;
                _noteRepo.delete(widget.user, _noteId).then((value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                });
              },
              icon: const Icon(Icons.delete),
            ),
            _readOnly ? buttonEdit : categoryView,
            IconButton(
              onPressed: () async {
                _noteId = await _saveOrUpdate(
                  _user,
                  _noteId,
                  jsonEncode(qc.document.toDelta()),
                  Category(_categorySelected),
                );
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
      );
      Widget divider = Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
      );
      Widget editorBody = Expanded(
        child: flutter_quill.QuillEditor(
          placeholder: "Start typing",
          controller: qc,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNodeEditorBody,
          autoFocus: true,
          readOnly: _readOnly,
          showCursor: !_readOnly,
          expands: false,
          padding: const EdgeInsets.all(10),
        ),
      );
      Widget editorTools = flutter_quill.QuillToolbar.basic(controller: qc);
      view = Column(
        children: [
          editorAppBar,
          divider,
          editorBody,
          divider,
          editorTools,
        ],
      );
    } else {
      view = const EditScreenPlaceHolder();
    }

    return WillPopScope(
      onWillPop: () => _onBackPressed(qc),
      child: Scaffold(
        body: SafeArea(child: view),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _quillController?.dispose();
    _categoryRepo.removeListener(key);
  }

  Future<bool> _onBackPressed(flutter_quill.QuillController? qc) async {
    if (qc != null) {
      final flutter_quill.Delta data = qc.document.toDelta();
      final String dataJsonArray = jsonEncode(data);
      _saveOrUpdate(_user, _noteId, dataJsonArray, Category(_categorySelected));
    }
    return true;
  }

  Future<int> _saveOrUpdate(
    User user,
    int? noteId,
    String dataJsonArray,
    Category category,
  ) async {
    int result = 0;
    if (noteId != null) {
      result = await _noteRepo.update(user, noteId, dataJsonArray, category);
    } else {
      result = await _noteRepo.save(user, dataJsonArray, category);
    }
    return result;
  }

  void _initialiseQuillController(Note? note) {
    flutter_quill.Document document;
    if (note != null) {
      document = flutter_quill.Document.fromJson(
        List.of(jsonDecode(note.jsonArray)),
      );
    } else {
      document = flutter_quill.Document.fromDelta(
        flutter_quill.Delta()..insert("\n"),
      );
    }

    _quillController = flutter_quill.QuillController(
      document: document,
      selection: const TextSelection.collapsed(
        offset: 0,
      ),
    );
  }

  void _onCategoryChange(ListenerType type, dynamic category) {
    if (type == ListenerType.add) {
      setState(() {
        _categories.add(category);
        _categorySelected = category;
      });
    }
  }

  // ignore: prefer_void_to_null
  Future<Null> _handleLoadDataError(dynamic onError) async {
    Navigator.of(context).pop("an error occurred, the editor cannot be opened");
  }
}
