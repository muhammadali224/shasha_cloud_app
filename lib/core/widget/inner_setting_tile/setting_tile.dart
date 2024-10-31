import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final IconData? trailing;
  final void Function()? onTap;
  final TextStyle? titleTextStyle;

  const SettingTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      this.trailing,
      this.onTap,
      this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          trailing: Icon(
            trailing ?? Icons.arrow_forward_ios_outlined,
            size: 15.h,
          ),
          title: AutoSizeText(title, style: titleTextStyle),
          subtitle: subtitle != null ? AutoSizeText(subtitle!.tr()) : null,
          leading: leading != null
              ? Icon(
                  leading,
                  size: 20.h,
                )
              : null,
        ),
        const Divider(height: 0),
      ],
    );
  }
}
