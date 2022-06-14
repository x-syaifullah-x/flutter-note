import 'package:flutter/cupertino.dart';
import 'package:submission_bmafup/data/category/category.dart';

typedef ItemOnLongPressed = Function(Category category);

class HomeScreenTabBarItem extends StatelessWidget {
  const HomeScreenTabBarItem(
    this._category,
    this.tabIndicatorHeight,
    this.tabIndicatorRadius,
    this.tabIndicatorColor, {
    Key? key,
    this.itemOnLongPressed,
  }) : super(key: key);

  final Category _category;
  final double tabIndicatorHeight;
  final ItemOnLongPressed? itemOnLongPressed;
  final double tabIndicatorRadius;
  final Color tabIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (_category.value == Category.ALL) return;
        itemOnLongPressed?.call(_category);
      },
      child: Container(
        height: tabIndicatorHeight,
        constraints: const BoxConstraints(
          minWidth: 65,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tabIndicatorRadius),
          border: Border.all(
            color: tabIndicatorColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Text(
            _category.value,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
