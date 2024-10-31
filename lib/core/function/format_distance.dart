import '../constant/app_strings.dart';

String formatDistance(num dis) {
  String distance = "";
  dis < 1
      ? distance = "${"${dis * 1000} ".split(".").first} ${AppStrings.m}"
      : distance = "${dis.toString().substring(0, 4)} ${AppStrings.km}";
  return distance;
}
