import 'package:flutter/material.dart';

import '../../../data/model/pop_menu_model/pop_menu_model.dart';

class AppPopMenu extends StatelessWidget {
  final List<AppPopMenuItemModel> items;
  final Widget? child;
  final void Function(int)? onSelected;
  final Offset? offset;

  const AppPopMenu(
      {super.key,
      required this.items,
      this.child,
      this.onSelected,
      this.offset});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => List.generate(
        items.length,
        (index) => PopupMenuItem(
          value: index + 1,
          onTap: items[index].onTap,
          enabled: items[index].enabled,
          child: ListTile(
            title: Text(items[index].title),
            leading: Icon(items[index].leading),
          ),
        ),
      ),
      offset: offset ?? const Offset(-30, 50),
      elevation: 10,
      onSelected: onSelected,
      child: child,
    );
  }
}
