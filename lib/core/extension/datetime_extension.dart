import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

extension DateTimeConverter on DateTime {
  String get toDMy =>
      Jiffy.parseFromDateTime(this).format(pattern: "yyyy-MM-dd");

  String get toDayMy =>
      Jiffy.parseFromDateTime(this).format(pattern: "EEEE ,yyyy-MM-dd");

  String get toDayMyHM =>
      Jiffy.parseFromDateTime(this).format(pattern: "EEEE ,yyyy-MM-dd h:mm a");

  String get toDayMyHmAR =>
      Jiffy.parseFromDateTime(this).format(pattern: "EEEE yyyy/MM/dd h:mm a");

  String get toDayMyHmARTicket =>
      Jiffy.parseFromDateTime(this).format(pattern: "EEEE MM/dd h:mm a");

  String get toDMyHm =>
      Jiffy.parseFromDateTime(this).format(pattern: "yyyy-MM-dd h:mm a");

  String get toReservationDate =>
      Jiffy.parseFromDateTime(this).format(pattern: "yyyy-MM-dd H:mm");

  String get toHm => Jiffy.parseFromDateTime(this).format(pattern: "hh:mm a");

  String get toDay => Jiffy.parseFromDateTime(this).format(pattern: "EEEE");

  String get toDate =>
      Jiffy.parseFromDateTime(this).format(pattern: "dd / MM/ yyyy");

  DateTime toTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}
