import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/text_style.dart';

class InnerSettingTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final int isActive;
  final void Function()? onTap;
  final void Function(bool)? onChanged;

  const InnerSettingTile(
      {super.key,
      required this.title,
      required this.subTitle,
      this.onTap,
      required this.isActive,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: AutoSizeText(
        title,
        style: AppTextStyle.style18B,
      ),
      subtitle: AutoSizeText(subTitle),
      trailing: Switch(
        value: isActive == 1 ? true : false,
        onChanged: onChanged,
      ),
    );
  }
}
