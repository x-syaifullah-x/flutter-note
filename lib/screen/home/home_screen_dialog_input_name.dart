import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/category/category_repository.dart';
import 'package:submission_bmafup/data/user/user.dart';
import 'package:submission_bmafup/data/category/category.dart';

class HomeScreenDialogInputName extends StatefulWidget {
  const HomeScreenDialogInputName(this._user, {Key? key}) : super(key: key);

  final User _user;

  @override
  State<StatefulWidget> createState() => _HomeScreenDialogInputNameState();
}

class _HomeScreenDialogInputNameState extends State<HomeScreenDialogInputName> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isEnter = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget w;

    if (_isEnter) {
      w = const AlertDialog(
        title: Text("Please wait ..."),
        content: SizedBox(
          width: 5,
          height: 5,
          child: LinearProgressIndicator(),
        ),
      );
    } else {
      w = AlertDialog(
        title: const Text("Name"),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Input name",
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("CANCEL"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Category category = Category(_textEditingController.text);
              if (category.value.isEmpty) {
                _showSnackBar("Please input category name");
                return;
              }

              if (mounted) {
                setState(() {
                  _isEnter = true;
                  CategoryRepository.getInstance().add(widget._user, category).then(
                      (value) {
                    if (!value) {
                      _showSnackBar("Failed to add");
                    }
                    Navigator.pop(context);
                  }, onError: (e) {
                    _showSnackBar("error when adding");
                    Navigator.pop(context);
                  });
                });
              }
            },
          ),
        ],
      );
    }
    return w;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
