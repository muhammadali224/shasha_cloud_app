extension MapExtension on Map {
  String get format {
    if (isEmpty) {
      return "";
    } else {
      var firstKey = entries.first.key;
      var mapValues = entries.first.value;
      return "?$firstKey=$mapValues";
    }
  }
}
