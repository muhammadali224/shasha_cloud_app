bool checkStoreOpen({
  required DateTime openAt,
  required DateTime closeAt,
}) {
  DateTime currentTime = DateTime.now();

  DateTime openDateTime = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
    openAt.hour,
    openAt.minute,
  );
  DateTime closeDateTime = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
    closeAt.hour,
    closeAt.minute,
  );
  return currentTime.isAfter(openDateTime) &&
      currentTime.isBefore(closeDateTime);
}
