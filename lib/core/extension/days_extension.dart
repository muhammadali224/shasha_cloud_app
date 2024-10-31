import '../enum/days.enum.dart';

extension DayExtension on Days {
  static Days fromInt(int dayId) {
    switch (dayId) {
      case 1:
        return Days.saturday;
      case 2:
        return Days.sunday;
      case 3:
        return Days.monday;
      case 4:
        return Days.tuesday;
      case 5:
        return Days.wednesday;
      case 6:
        return Days.thursday;
      case 7:
        return Days.friday;
      case 8:
        return Days.allDays;
      default:
        throw ArgumentError("Invalid dayId");
    }
  }

  static int toInt(Days day) {
    switch (day) {
      case Days.saturday:
        return 1;
      case Days.sunday:
        return 2;
      case Days.monday:
        return 3;
      case Days.tuesday:
        return 4;
      case Days.wednesday:
        return 5;
      case Days.thursday:
        return 6;
      case Days.friday:
        return 7;
      case Days.allDays:
        return 8;
    }
  }

  static Days currentDay() {
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;

    int adjustedCurrentDay = (currentDayOfWeek % 7) + 2;

    return fromInt(adjustedCurrentDay);
  }
}
