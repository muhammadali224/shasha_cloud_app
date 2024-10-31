import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../main.dart';
import 'awesome_notification.service.dart';

class FcmHelper {
  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (error) {
      logger.e(error);
    }
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      if (token != null) {
        // getIt<AppServices>().appBox.put(BoxKey.firebaseToken, token);
        // _sendFcmTokenToServer();
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      logger.e(error);
    }
  }

  // static _sendFcmTokenToServer() {
  //   getIt<AppServices>().appBox.get(BoxKey.firebaseToken);
  // }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    _handleNotification(message);
  }

  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    _handleNotification(message);
  }

  static void _handleNotification(RemoteMessage message) {
    if (message.notification != null) {
      NotificationsController.createNewNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          bigPicture: '',
          payload: message.data.cast<String, String>());
    }
  }
}
