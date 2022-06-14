import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/category/category.dart';
import 'package:submission_bmafup/data/category/category_repository.dart';
import 'package:submission_bmafup/data/listener.dart';
import 'package:submission_bmafup/data/user/user.dart';
import 'package:submission_bmafup/screen/home/home_screen_dialog_confirm_delete_tab_bar.dart';
import 'package:submission_bmafup/screen/home/home_screen_dialog_input_name.dart';
import 'package:submission_bmafup/screen/home/home_screen_drawer.dart';
import 'package:submission_bmafup/screen/home/home_screen_tab_bar.dart';
import 'package:submission_bmafup/screen/home/home_screen_tab_bar_view.dart';
import 'package:submission_bmafup/screen/utils/sliver_appbar_delegate.dart';

import 'home_screen_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this._user, {Key? key}) : super(key: key);

  final User _user;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final CategoryRepository _categoryRepo = CategoryRepository.getInstance();
  final List<Category> _categories = [];

  TabController? _tabController;

  final String key = "_HomeScreenState";

  void _updateTabBar(int length) {
    setState(() {
      _tabController = TabController(vsync: this, length: length);
    });
  }

  @override
  void dispose() {
    _categoryRepo.removeListener(key);
    super.dispose();
  }

  @override
  void initState() {
    _categoryRepo.getCategories(widget._user).then((categories) {
      _categories.clear();
      _categories.addAll(categories);
      _updateTabBar(categories.length);
    });

    _categoryRepo.setOnChangeListener(key, (type, category) {
      switch (type) {
        case ListenerType.add:
          _categories.add(category);
          break;
        case ListenerType.update:
          break;
        case ListenerType.delete:
          _categories.remove(category);
          break;
      }
      _updateTabBar(_categories.length);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget tabBar;
    Widget tabBarView;
    final TabController? tabController = _tabController;

    double tabBarMinHeight = tabController == null ? 4 : 110;
    double tabBarMaxHeight = tabController == null ? 4 : 115;

    if (tabController != null) {
      tabBar = HomeScreenTabBar(
        _categories,
        tabController,
        iconAddOnPressed: () {
          showDialog(
            context: context,
            builder: (builder) => HomeScreenDialogInputName(widget._user),
            barrierDismissible: false,
          );
        },
        itemOnLongPressed: (category) {
          showDialog(
            context: context,
            builder: (builder) => HomeScreenDialogConfirmDeleteTabBar(
              widget._user,
              category,
            ),
            barrierDismissible: false,
          ).then(_onDeleteTabBar);
        },
      );
      tabBarView = HomeScreenTabBarView(
        widget._user,
        _categories,
        tabController,
      );
    } else {
      tabBar = const LinearProgressIndicator();
      tabBarView = const SizedBox(
        height: 60,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        drawer: DrawerHome(
          key: widget.key,
        ),
        body: SafeArea(
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (BuildContext c, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  forceElevated: innerBoxIsScrolled,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: tabBarMinHeight,
                    maxHeight: tabBarMaxHeight,
                    child: tabBar,
                  ),
                ),
              ];
            },
            body: tabBarView,
          ),
        ),
        floatingActionButton: HomeScreenFab(
          widget._user,
          key: widget.key,
          getCategory: () {
            Category? category;
            if (_categories.isNotEmpty) {
              category = _categories[tabController?.index ?? 0];
            }
            return category;
          },
        ),
      ),
    );
  }

  void _onDeleteTabBar(dynamic message) {
    String msg = message[HomeScreenDialogConfirmDeleteTabBar.resultKey];
    bool isSuccess =
        msg == HomeScreenDialogConfirmDeleteTabBar.resultMessageSuccess;
    if (isSuccess) return;
    bool isCancel =
        msg == HomeScreenDialogConfirmDeleteTabBar.resultMessageCancel;
    if (isCancel) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
