// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
//
// Future<String> getDeviceSN() async {
//   String id = "";
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     id = iosInfo.identifierForVendor!;
//   } else if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     id = androidInfo.id;
//   }
//   return id;
// }
