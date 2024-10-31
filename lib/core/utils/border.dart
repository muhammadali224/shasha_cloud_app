import 'package:flutter/material.dart';

import 'border_radius.dart';
import 'color.dart';

abstract class AppWidgetBorder {
  AppWidgetBorder._();

  static InputBorder enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColor.primaryColor),
    borderRadius: BorderRadius.circular(AppBorderRadius.sm8),
  );

  static InputBorder disabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColor.grey,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.sm8),
  );
  static InputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColor.primaryColor,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.sm8),
  );
  static InputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColor.red,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.sm8),
  );
  static InputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColor.primaryColor,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.sm8),
  );
}
