import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../data/model/notification_payload_model/notification_payload_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  void addNotification(NotificationPayloadModel notification) {
    emit(NotificationsNewPayLoad(payloadModel: notification));
  }
}
