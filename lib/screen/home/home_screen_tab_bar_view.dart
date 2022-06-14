import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/category/category.dart';
import 'package:submission_bmafup/data/note/note_repository.dart';
import 'package:submission_bmafup/data/user/user.dart';

import '../../data/listener.dart';
import '../../data/note/note.dart';
import 'home_screen_no_result.dart';
import 'home_screen_tab_bar_view_content.dart';

class HomeScreenTabBarView extends StatefulWidget {
  const HomeScreenTabBarView(
    this._user,
    this._categories,
    this._tabController, {
    Key? key,
  }) : super(key: key);

  final User _user;
  final List<Category> _categories;
  final TabController _tabController;

  @override
  State<StatefulWidget> createState() => _HomeScreenTabBarViewState();
}

class _HomeScreenTabBarViewState extends State<HomeScreenTabBarView> {
  final NoteRepository _noteRepo = NoteRepository.getInstance();
  final List<Note> _notes = [];
  final String keyNoteOnChangeListener = "_HomeScreenTabBarViewState";

  bool _isLoaded = false;

  bool _isError = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _setOnNoteChangeListener() {
    _noteRepo.setOnChangeListener(keyNoteOnChangeListener, (type, note) {
      setState(() {
        if (type == ListenerType.add) {
          _notes.add(note);
        } else if (type == ListenerType.update) {
          int index = _notes.indexWhere((e) => (e.id == note.id));
          _notes.removeAt(index);
          _notes.add(note);
        } else if (type == ListenerType.delete) {
          int index = _notes.indexWhere((e) => (e.id == note.id));
          _notes.remove(_notes[index]);
        }
      });
    });
  }

  void _initialiseNotes() {
    setState(() {
      _isLoaded = true;
    });
    _noteRepo.getNotes(widget._user).then((notes) {
      setState(() {
        _notes.clear();
        _notes.addAll(notes);
        _isLoaded = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoaded = false;
        _isError = true;
        _showSnackBar(onError);
      });
    });
  }

  @override
  void initState() {
    _initialiseNotes();
    _setOnNoteChangeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget._tabController,
      children: widget._categories.map((category) {
        final List<Note> notes;
        if (category.value == Category.ALL) {
          notes = _notes;
        } else {
          notes = _notes.where((note) => (note.category == category)).toList();
        }

        final Widget view;
        if (_isLoaded) {
          view = const SizedBox(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (_isError) {
          view = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ic_error.png",
                width: 130,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text("Sorry, an error occurred"),
              ElevatedButton(
                onPressed: () {
                  _initialiseNotes();
                },
                child: const Text("Reload"),
              )
            ],
          );
        } else if (notes.isEmpty) {
          view = const NoResult();
        } else {
          view = TabBarViewContent(widget._user, notes);
        }
        return view;
      }).toList(),
    );
  }

  @override
  void dispose() {
    _noteRepo.removeListener(keyNoteOnChangeListener);
    super.dispose();
  }
}
