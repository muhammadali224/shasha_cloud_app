import 'dart:io';

import '../../main.dart';

Future<bool> checkInternet() async {
  try {
    try {
      var result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        logger.i("connected");
        return true;
      }
    } on SocketException catch (_) {
      logger.e("Error Check Internet : No Internet Connection");
      return false;
    }
  } catch (e) {
    logger.e("Error Check Internet : $e");
    throw Exception("Error Check Internet $e");
  }

  return false;
}
