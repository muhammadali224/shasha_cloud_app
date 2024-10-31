import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/assets.dart';
import '../../constant/app_strings.dart';
import '../../extension/space_extension.dart';
import '../../utils/text_style.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    SmartDialog.dismiss();
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 0.5.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Lottie.asset(Assets.lottieNoInternet, repeat: false)),
              10.gap,
              Expanded(
                child: AutoSizeText(
                  AppStrings.checkInternet.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.style24B,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
