import 'package:easy_localization/easy_localization.dart';

import '../constant/app_strings.dart';

extension IntegerExtension on num {
  String get toTime {
    String time = "";
    if (this == 0) {
      time = AppStrings.now.tr();
    } else if (this < 60) {
      time = "$this ${AppStrings.minute}";
    } else {
      var hours = this ~/ 60;
      var minutes = this % 60;
      time =
          "$hours:${minutes.toString().padLeft(2, '0')} ${hours > 1 ? AppStrings.hours : AppStrings.hour}";
    }

    return time;
  }
}
