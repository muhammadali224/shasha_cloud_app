import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/app_strings.dart';
import '../utils/color.dart';

Future<File?> imagePicker(ImageSource src) async {
  XFile? xFile = await ImagePicker().pickImage(source: src);
  if (xFile?.path == null) {
    SmartDialog.showToast(AppStrings.selectImageError.tr(),
        maskColor: AppColor.red);
  } else {
    return File(xFile!.path);
  }
  return null;
}

Future<File?> videoPicker(ImageSource src) async {
  XFile? xFile = await ImagePicker().pickVideo(source: src);
  if (xFile?.path == null) {
    SmartDialog.showToast(AppStrings.selectImageError.tr(),
        maskColor: AppColor.red);
  } else {
    return File(xFile!.path);
  }
  return null;
}
