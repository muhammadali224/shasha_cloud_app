import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../core/constant/box_key.dart';
import '../core/services/api.service.dart';
import '../core/services/app.service.dart';
import '../data/api/firebase/auth_data/auth_data.dart';
import '../data/api/firebase/client_data/client_data.dart';
import '../data/api/firebase/screen_media_data/screen_media_data.dart';
import '../data/model/user_model/user_model.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  //======================== Dio ===============================================
  getIt.registerSingleton<AppServices>(AppServices());

  //======================== Api Services ======================================
  getIt.registerSingleton<ApiServices>(ApiServices(Dio()));

  //======================== Hive Boxes ========================================
  final userBox = await Hive.openBox<UserModel>(BoxKey.user);
  getIt.registerSingleton<Box<UserModel>>(userBox);

  final appBox = await Hive.openBox(BoxKey.appBox);
  getIt.registerSingleton<Box>(appBox);

  //========================  Firebase =========================================
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  //========================  Auth Repo ========================================
  getIt.registerSingleton<AuthData>(
    AuthData(
        firebaseAuth: getIt<FirebaseAuth>(),
        firebaseFirestore: getIt<FirebaseFirestore>()),
  );
  //========================  Client Repo ======================================
  getIt.registerSingleton<ClientData>(
    ClientData(firebaseFirestore: getIt<FirebaseFirestore>()),
  );

  //========================  Media Screen Repo ================================
  getIt.registerSingleton<ScreenMediaData>(
    ScreenMediaData(firebaseFirestore: getIt<FirebaseFirestore>()),
  );
}
