import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

import 'home_screen_tab_bar_item.dart';
import 'package:submission_bmafup/data/category/category.dart';

class HomeScreenTabBar extends StatelessWidget {
  const HomeScreenTabBar(
    this._categories,
    this._tabController, {
    Key? key,
    this.iconAddOnPressed,
    this.itemOnLongPressed,
  }) : super(key: key);

  final List<Category> _categories;
  final TabController _tabController;
  final VoidCallback? iconAddOnPressed;
  final ItemOnLongPressed? itemOnLongPressed;

  @override
  Widget build(BuildContext context) {
    const double tabIndicatorHeight = 35.0;
    const double tabIndicatorRadius = 14;
    final Color tabIndicatorColor =
        Theme.of(context).appBarTheme.backgroundColor ?? Colors.blue;
    final Widget tabBarTitle = Container(
      margin: const EdgeInsets.only(
        left: 14,
        top: 10,
        bottom: 5,
      ),
      child: Text(
        "Watchlist",
        style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: tabIndicatorColor),
      ),
    );
    final Widget itemAdd = GestureDetector(
      onTap: iconAddOnPressed,
      child: Container(
        height: tabIndicatorHeight,
        width: 90,
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tabIndicatorRadius),
          border: Border.all(
            color: tabIndicatorColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: tabIndicatorColor),
            Text("ADD", style: TextStyle(color: tabIndicatorColor)),
          ],
        ),
      ),
    );
    final Widget itemCategories = Expanded(
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.all(4),
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: tabIndicatorColor,
        indicator: BubbleTabIndicator(
          indicatorHeight: tabIndicatorHeight,
          indicatorColor: tabIndicatorColor,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
          indicatorRadius: tabIndicatorRadius,
          insets: const EdgeInsets.only(
            left: 4,
            right: 4,
            bottom: 1,
            top: -1,
          ),
        ),
        tabs: _categories.map((categories) {
          return HomeScreenTabBarItem(
            categories,
            tabIndicatorHeight,
            tabIndicatorRadius,
            tabIndicatorColor,
            itemOnLongPressed: itemOnLongPressed,
          );
        }).toList(),
      ),
    );
    final Widget tabBarItem = Row(
      children: [itemAdd, itemCategories],
    );
    final Widget view = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [tabBarTitle, tabBarItem],
      ),
    );
    return view;
  }
}
