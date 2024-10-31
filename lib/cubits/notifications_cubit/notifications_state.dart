part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsError extends NotificationsState {
  final String errorMessage;

  NotificationsError({required this.errorMessage});
}

final class NotificationsNewPayLoad extends NotificationsState {
  final NotificationPayloadModel payloadModel;

  NotificationsNewPayLoad({required this.payloadModel});
}
