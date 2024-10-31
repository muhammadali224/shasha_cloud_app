import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../context/global.dart';

String translateByLocale({required String nameAr, required String nameEn}) {
  final locale = EasyLocalization.of(GlobalContext.context)?.locale;

  if (locale == const Locale('en')) {
    return nameEn;
  } else {
    return nameAr;
  }
}
