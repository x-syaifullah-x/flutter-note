import 'package:flutter/material.dart';

import '../../data/category/category.dart';
import '../../data/user/user.dart';
import '../edit/edit_screen.dart';

typedef GetCategory = Category? Function();

class HomeScreenFab extends StatelessWidget {
  const HomeScreenFab(
    this._user, {
    Key? key,
    this.getCategory,
  }) : super(key: key);

  final User _user;
  final GetCategory? getCategory;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => EditScreen(
              user: _user,
              category: getCategory?.call(),
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
