import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import 'language/ar.dart';
import 'language/en.dart';

class Translation {
  static const Map<String, dynamic> en = enLan;
  static const Map<String, dynamic> ar = arLan;
}

class CodeAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return Translation.en;
      case 'ar':
        return Translation.ar;
      default:
        return Translation.en;
    }
  }
}
