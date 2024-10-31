import 'package:flutter/cupertino.dart';

class AppPopMenuItemModel {
  String title;
  void Function()? onTap;
  bool enabled;

  IconData? leading;

  AppPopMenuItemModel({
    required this.title,
    required this.leading,
    this.enabled = true,
    required this.onTap,
  });
}
