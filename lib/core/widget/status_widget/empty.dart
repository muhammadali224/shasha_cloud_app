import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../core/extension/space_extension.dart';
import '../../../core/utils/text_style.dart';

class Empty extends StatelessWidget {
  final String imageName;
  final String title;
  final bool? repeat;

  const Empty(
      {super.key, required this.imageName, required this.title, this.repeat});

  @override
  Widget build(BuildContext context) {
    SmartDialog.dismiss();
    return Center(
      child: SizedBox(
        height: 0.5.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Lottie.asset(imageName, repeat: repeat ?? false)),
            10.gap,
            Expanded(
              child: AutoSizeText(
                title.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.style24B,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
