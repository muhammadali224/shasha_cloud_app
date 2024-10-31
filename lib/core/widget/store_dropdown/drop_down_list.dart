import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_strings.dart';

class DropDownList<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final void Function(T?) onChangeTap;
  final List<DropdownMenuItem<T>> items;
  final bool? isExpanded;
  final EdgeInsetsGeometry? contentPadding;

  const DropDownList(
      {super.key,
      required this.labelText,
      required this.value,
      required this.onChangeTap,
      required this.items,
      this.isExpanded,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: isExpanded ?? true,
      decoration: InputDecoration(
          contentPadding:
              contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText.tr(),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 0.5))),
      value: value,
      items: items,
      enableFeedback: true,
      onChanged: onChangeTap,
      validator: (value) {
        if (value == null || value == "0") {
          return AppStrings.selectedError.tr(args: [AppStrings.section.tr()]);
        }
        return null;
      },
    );
  }
}
