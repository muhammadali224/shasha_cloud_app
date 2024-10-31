import 'package:flutter/material.dart';

import '../constant/app_strings.dart';

enum ReservationStatus {
  none("", AppStrings.noneReservation, Colors.white),
  pending("0", AppStrings.pendingReservation, Colors.orange),
  confirmed("1", AppStrings.confirmedReservation, Colors.green),
  rejected("2", AppStrings.rejectedReservation, Colors.red),
  cancelledByStore("3", AppStrings.cancelledByStoreReservation, Colors.red),
  cancelledByUser("4", AppStrings.cancelledByUserReservation, Colors.red),
  expired("5", AppStrings.expiredReservation, Colors.grey),
  done("6", AppStrings.doneReservation, Colors.green),
  delayed("7", AppStrings.delayedReservation, Colors.blueGrey),
  success("8", AppStrings.successReservation, Colors.green),
  inService("9", AppStrings.inServiceReservation, Colors.green);

  final String value;
  final String title;
  final Color color;

  const ReservationStatus(this.value, this.title, this.color);
}
