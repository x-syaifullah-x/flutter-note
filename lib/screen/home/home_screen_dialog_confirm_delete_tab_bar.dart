import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/category/category_repository.dart';
import 'package:submission_bmafup/data/user/user.dart';
import 'package:submission_bmafup/data/category/category.dart';

class HomeScreenDialogConfirmDeleteTabBar extends StatefulWidget {
  const HomeScreenDialogConfirmDeleteTabBar(
    this._user,
    this._category, {
    Key? key,
  }) : super(key: key);

  static const String resultKey = "HomeScreenDialogConfirmDeleteTabBar";
  static const String resultMessageCancel = "Cancel";
  static const String resultMessageSuccess = "Successful";

  final User _user;
  final Category _category;

  @override
  State<StatefulWidget> createState() =>
      _HomeScreenDialogConfirmDeleteTabBarState();
}

class _HomeScreenDialogConfirmDeleteTabBarState
    extends State<HomeScreenDialogConfirmDeleteTabBar> {
  bool _isEnter = false;

  @override
  Widget build(BuildContext context) {
    Widget title;
    Widget content;
    List<Widget>? action;

    if (_isEnter) {
      title = const Text("Please wait ...");
      content = const SizedBox(
        height: 4,
        child: LinearProgressIndicator(),
      );
    } else {
      title = const Text("Delete Confirm");
      content = const Text("Are you sure want to delete");
      final Widget actionOk = TextButton(
        child: const Text("OK"),
        onPressed: () {
          setState(() {
            _isEnter = true;
            CategoryRepository.getInstance()
                .delete(widget._user, widget._category)
                .then((value) {
              if (!value) {
                _finishDialog(
                    "An error occurred, failed to delete tab ${widget._category}");
              } else {
                _finishDialog(
                    HomeScreenDialogConfirmDeleteTabBar.resultMessageSuccess);
              }
            }, onError: (e) {
              _finishDialog("$e");
            });
          });
        },
      );
      final Widget actionCancel = TextButton(
        child: const Text("CANCEL"),
        onPressed: () => _finishDialog(
          HomeScreenDialogConfirmDeleteTabBar.resultMessageCancel,
        ),
      );
      action = [actionCancel, actionOk];
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: action,
    );
  }

  void _finishDialog(String message) {
    return Navigator.pop(context, {
      HomeScreenDialogConfirmDeleteTabBar.resultKey: message,
    });
  }
}
