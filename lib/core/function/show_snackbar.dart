import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

enum BarType { snackbar, materialBanner }

ScaffoldMessengerState showBar(
    {required String title,
    required String message,
    required ContentType contentType,
    BarType barType = BarType.snackbar,
    required BuildContext context,
    List<Widget>? actions}) {
  if (barType == BarType.materialBanner) {
    return ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
          inMaterialBanner: true,
        ),
        actions: actions ?? [const SizedBox.shrink()],
      ));
  } else {
    return ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      );
  }
}
