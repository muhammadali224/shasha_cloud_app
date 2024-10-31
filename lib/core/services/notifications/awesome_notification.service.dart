import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../cubits/notifications_cubit/notifications_cubit.dart';
import '../../../data/model/notification_channel_model/notification_channel_model.dart';
import '../../../data/model/notification_payload_model/notification_payload_model.dart';
import '../../../main.dart';
import '../../constant/notification_channel.dart';
import '../../context/global.dart';

class NotificationsController {
  static ReceivedAction? initialAction;

  // ***************************************************************
  //    INITIALIZATIONS
  // ***************************************************************
  static Future<void> initializeLocalNotifications() async {
    await initializeIsolateReceivePort();
    await AwesomeNotifications().initialize(
        "resource://drawable/app_icon",
        [
          NotificationChannel(
              channelGroupKey: NotificationChannelKey.basicChannel.groupKey,
              channelKey: NotificationChannelKey.basicChannel.key,
              channelName: NotificationChannelKey.basicChannel.name,
              channelDescription:
                  NotificationChannelKey.basicChannel.description,
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white,
              // soundSource: "resource://raw/noti_sound",
              importance: NotificationImportance.High),
          NotificationChannel(
              channelGroupKey: NotificationChannelKey.basicChannel.groupKey,
              channelKey: NotificationChannelKey.basicChannel.key,
              channelName: 'Badge indicator notifications',
              channelDescription:
                  'Notification channel to activate badge indicator',
              channelShowBadge: true,
              // soundSource: "resource://raw/noti_sound",
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.yellow),
          NotificationChannel(
              channelGroupKey: NotificationChannelKey.categoryChannel.groupKey,
              channelKey: NotificationChannelKey.categoryChannel.key,
              channelName: NotificationChannelKey.categoryChannel.name,
              channelDescription:
                  NotificationChannelKey.categoryChannel.description,
              // soundSource: "resource://raw/noti_sound",
              defaultColor: const Color(0xFF9D50DD),
              importance: NotificationImportance.Max,
              ledColor: Colors.white,
              channelShowBadge: true,
              locked: true,
              defaultRingtoneType: DefaultRingtoneType.Ringtone),
          NotificationChannel(
              channelGroupKey: NotificationChannelKey.categoryChannel.groupKey,
              channelKey: NotificationChannelKey.alarmChannel,
              channelName: 'Alarms Channel',
              // soundSource: "resource://raw/noti_sound",
              channelDescription: 'Channel with alarm ringtone',
              defaultColor: const Color(0xFF9D50DD),
              importance: NotificationImportance.Max,
              ledColor: Colors.white,
              channelShowBadge: true,
              locked: true,
              defaultRingtoneType: DefaultRingtoneType.Alarm),
          NotificationChannel(
            channelGroupKey: NotificationChannelKey.scheduleChannel.groupKey,
            channelKey: NotificationChannelKey.scheduleChannel.key,
            channelName: NotificationChannelKey.scheduleChannel.name,
            // soundSource: "resource://raw/noti_sound",
            channelDescription:
                NotificationChannelKey.scheduleChannel.description,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            vibrationPattern: lowVibrationPattern,
            importance: NotificationImportance.High,
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            criticalAlerts: true,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic', channelGroupName: 'Basic'),
          NotificationChannelGroup(
              channelGroupKey: 'category', channelGroupName: 'Category'),
          NotificationChannelGroup(
              channelGroupKey: 'schedule', channelGroupName: 'Schedule'),
        ],
        debug: true);
    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationsController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationsController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationsController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationsController.onDismissActionReceivedMethod);
  }

  // ***************************************************************
  //    ON ACTION EVENT REDIRECTION TO MAIN ISOLATE
  // ***************************************************************

  static ReceivePort? receivePort;

  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate');
    receivePort!.listen((serializedData) {
      final receivedAction = ReceivedAction().fromMap(serializedData);
      onActionReceivedMethodImpl(receivedAction);
    });

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  // ***************************************************************
  //    NOTIFICATIONS EVENT LISTENERS
  // ***************************************************************
  ///  Notifications events are only delivered after call this method
  // static Future<void> startListeningNotificationEvents() async {
  //   AwesomeNotifications()
  //       .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  // }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    var message =
        'Notification created on ${receivedNotification.createdLifeCycle?.name}';
    logger.d(message);
    SmartDialog.showToast(message);
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    var message1 =
        'Notification displayed on ${receivedNotification.displayedLifeCycle?.name}';
    var message2 =
        'Notification displayed at ${receivedNotification.displayedDate}';

    logger.d(message1);
    logger.d(message2);
    SmartDialog.showToast(message1);
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    var message =
        'Notification dismissed on ${receivedAction.dismissedLifeCycle?.name}';
    SmartDialog.showToast(message);
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivePort != null) {
      await onActionReceivedMethodImpl(receivedAction);
    } else {
      logger.d(
          'onActionReceivedMethod was called inside a parallel dart isolate, where receivePort was never initialized.');
      SendPort? sendPort =
          IsolateNameServer.lookupPortByName('notification_action_port');

      if (sendPort != null) {
        logger.d(
            'Redirecting the execution to main isolate process in listening...');
        dynamic serializedData = receivedAction.toMap();
        sendPort.send(serializedData);
      }
    }
  }

  static Future<void> onActionReceivedMethodImpl(
      ReceivedAction receivedAction) async {
    var message =
        'Action ${receivedAction.actionType?.name} received on ${receivedAction.actionLifeCycle?.name}';
    logger.d(message);

    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();
  }

  // ***************************************************************
  //    NOTIFICATIONS HANDLING METHODS
  // ***************************************************************

  static Future<void> interceptInitialCallActionRequest() async {
    ReceivedAction? receivedAction =
        await AwesomeNotifications().getInitialNotificationAction();

    if (receivedAction?.channelKey == 'call_channel') {
      initialAction = receivedAction;
    }
  }

  //  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification({
    required String title,
    required String body,
    String? bigPicture,
    NotificationChannelModel? channel,
    required Map<String, String?> payload,
  }) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        handleNotificationPayload(GlobalContext.context, payload.cast());

        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: -1,
              // -1 is replaced by a random number
              channelKey:
                  channel?.key ?? NotificationChannelKey.basicChannel.key,
              title: title,
              body: body,
              bigPicture: bigPicture,
              // 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
              // largeIcon: "asset://${Assets.imagesLogo3N}",
              notificationLayout: NotificationLayout.BigPicture,
              payload: payload),
        );
      }
    });
  }

  static scheduleNotification({
    required String title,
    required String body,
    required int id,
    required DateTime date,
    Map<String, String?>? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        title: title,
        body: body,
        wakeUpScreen: true,
        autoDismissible: false,
        category: NotificationCategory.Reminder,
        groupKey: NotificationChannelKey.scheduleChannel.groupKey,
        channelKey: NotificationChannelKey.scheduleChannel.key,
        payload: payload,
      ),
      schedule: NotificationCalendar
          // .fromDate(
          // date: date, allowWhileIdle: true, preciseAlarm: true));
          (
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        second: date.second,
        allowWhileIdle: true,
        preciseAlarm: true,
        repeats: true,
      ),
      actionButtons: [
        // NotificationActionButton(
        //   key: AppStrings.navigateToStore,
        //   label: AppStrings.navigateToStore,
        // ),
        // NotificationActionButton(
        //   key: AppStrings.call,
        //   label: AppStrings.call,
        //   color: Colors.green,
        // ),
      ],
    );
  }

  static void handleNotificationPayload(
      BuildContext context, Map<String, dynamic> payload) {
    final notificationCubit = context.read<NotificationsCubit>();

    final notificationModel = NotificationPayloadModel.fromJson(payload);

    notificationCubit.addNotification(notificationModel);

    // switch (notificationModel.topic) {
    // case 'new_reservation':
    //   // context.read<TodayReservationCubit>().getTodayReservation();
    //   context.read<TodayReservationCubit>().clearAndFetchReservations();
    //   break;
    // }
  }

  static cancelScheduleNotification({required int id}) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  static cancelAllScheduleNotification() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> getAllScheduleNotifications() async {
    List<NotificationModel> allScheduleNotifications =
        await AwesomeNotifications().listScheduledNotifications();
    logger.e(allScheduleNotifications.length);
    logger.e("Scheduled Notifications :$allScheduleNotifications");
  }
}
