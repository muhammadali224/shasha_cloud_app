import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../enum/reservation.enum.dart';

extension GetReservationStatus on String {
  String get reservationStatus {
    switch (this) {
      case "":
        return ReservationStatus.none.title.tr();

      case "0":
        return ReservationStatus.pending.title.tr();

      case "1":
        return ReservationStatus.confirmed.title.tr();

      case "2":
        return ReservationStatus.rejected.title.tr();

      case "3":
        return ReservationStatus.cancelledByStore.title.tr();

      case "4":
        return ReservationStatus.cancelledByUser.title.tr();

      case "5":
        return ReservationStatus.expired.title.tr();

      case "6":
        return ReservationStatus.done.title.tr();

      case "7":
        return ReservationStatus.delayed.title.tr();

      case "8":
        return ReservationStatus.success.title.tr();
      case "9":
        return ReservationStatus.inService.title.tr();
      default:
        return "";
    }
  }

  Color get reservationStatusColor {
    switch (this) {
      case "":
        return ReservationStatus.none.color;

      case "0":
        return ReservationStatus.pending.color;

      case "1":
        return ReservationStatus.confirmed.color;

      case "2":
        return ReservationStatus.rejected.color;

      case "3":
        return ReservationStatus.cancelledByStore.color;

      case "4":
        return ReservationStatus.cancelledByUser.color;

      case "5":
        return ReservationStatus.expired.color;

      case "6":
        return ReservationStatus.done.color;

      case "7":
        return ReservationStatus.delayed.color;

      case "8":
        return ReservationStatus.success.color;
      default:
        return Colors.transparent;
    }
  }

  String get reservationStatusValue {
    switch (this) {
      case "":
        return ReservationStatus.none.value;

      case "0":
        return ReservationStatus.pending.value;

      case "1":
        return ReservationStatus.confirmed.value;

      case "2":
        return ReservationStatus.rejected.value;

      case "3":
        return ReservationStatus.cancelledByStore.value;

      case "4":
        return ReservationStatus.cancelledByUser.value;

      case "5":
        return ReservationStatus.expired.value;

      case "6":
        return ReservationStatus.done.value;

      case "7":
        return ReservationStatus.delayed.value;

      case "8":
        return ReservationStatus.success.value;
      default:
        return "";
    }
  }
}
