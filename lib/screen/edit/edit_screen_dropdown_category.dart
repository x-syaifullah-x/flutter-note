import 'package:flutter/material.dart';

typedef DropDownCategoryOnSelected = Function(String);

class DropDownCategory extends StatelessWidget {
  const DropDownCategory(
      this._selected,
      this._items, {
        Key? key,
        this.onSelected,
      }) : super(key: key);

  final String _selected;
  final List<String> _items;
  final DropDownCategoryOnSelected? onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: _selected,
        items: _items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList()
          ..add(
            DropdownMenuItem(
              value: "ADD",
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 10),
                    const Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ),
        onChanged: (value) => onSelected?.call(("$value")),
      ),
    );
  }
}
