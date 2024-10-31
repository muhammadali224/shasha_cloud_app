import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../firebase_options.dart';

class AppServices {
  // Box appBox = Hive.box(BoxKey.appBox);

  Future<void> initAppServices() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBQvaLYksKJsVk33YReSQzqs7XmDdpmzag",
              authDomain: "restaurant-lcd.firebaseapp.com",
              projectId: "restaurant-lcd",
              storageBucket: "restaurant-lcd.appspot.com",
              messagingSenderId: "735344118479",
              appId: "1:735344118479:web:d0aaf744db0e3b66cdc5ba",
              measurementId: "G-FTM8P9EYX2"));
    } else {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
    setPathUrlStrategy();

    // await dotenv.load(fileName: ".env");
    Future.wait(
      [
        EasyLocalization.ensureInitialized(),
        ScreenUtil.ensureScreenSize(),
      ],
    );

    // await FcmHelper.initFcm();
    // await NotificationsController.initializeLocalNotifications();
    // await NotificationsController.initializeIsolateReceivePort();
    // NotificationsController.startListeningNotificationEvents();
  }

// Future<String?> get token async => await appBox.get(BoxKey.token);

// Future<void> _initUser() async {
//   try {
//     final admin = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: "admin@test.com", password: "123456");
//     if (admin.user != null) {
//       try {
//         FirebaseFirestore.instance
//             .collection("users")
//             .doc(admin.user!.uid)
//             .set({
//           'email': "admin@test.com",
//           'role': "admin",
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
// }
}
