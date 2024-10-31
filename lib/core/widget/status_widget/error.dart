import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/assets.dart';
import '../../constant/app_strings.dart';
import '../../extension/space_extension.dart';
import '../../function/show_snackbar.dart';
import '../../utils/text_style.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final bool? repeat;
  final String? buttonName;
  final void Function()? onTap;

  const ErrorScreen(
      {super.key,
      required this.errorMessage,
      this.repeat,
      this.buttonName,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    SmartDialog.dismiss();
    WidgetsBinding.instance.addPostFrameCallback((_) => showBar(
        title: AppStrings.error.tr(),
        message: errorMessage.tr(),
        context: context,
        contentType: ContentType.failure));
    return Center(
      child: SizedBox(
        height: 0.5.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child:
                    Lottie.asset(Assets.lottieError, repeat: repeat ?? false)),
            10.gap,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                errorMessage.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.style24B,
              ),
            ),
            if (buttonName != null && onTap != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: onTap,
                  child: AutoSizeText(buttonName!.tr(),
                      style: AppTextStyle.style16B),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
