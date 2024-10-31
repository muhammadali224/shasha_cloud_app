import '../constant/app_strings.dart';

bool responseCheck(Map<String, dynamic> response,
    {String? message, int? status}) {
  String responseMessage = message ?? AppStrings.success;
  int responseCode = status ?? 200;
  if (response[AppStrings.status] == responseCode &&
      response[AppStrings.message] == responseMessage) {
    return true;
  }
  return false;
}
