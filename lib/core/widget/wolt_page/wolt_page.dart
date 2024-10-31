import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../../core/utils/text_style.dart';

SliverWoltModalSheetPage woltPage({
  void Function()? onTapBack,
  required void Function() onTapCancel,
  bool withBackButton = true,
  required String title,
  Widget? heroImage,
  double? heroImageHeight,
  required Widget child,
}) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    leadingNavBarWidget: withBackButton
        ? IconButton(
            icon: const Icon(Icons.arrow_back_rounded), onPressed: onTapBack)
        : null,
    topBarTitle: AutoSizeText(title, style: AppTextStyle.style20B),
    heroImage: heroImage,
    heroImageHeight: heroImageHeight,
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(10),
        icon: const Icon(Icons.close),
        onPressed: onTapCancel),
    child: child,
  );
}
