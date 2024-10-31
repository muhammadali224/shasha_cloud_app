import 'package:hive_flutter/adapters.dart';

import '../../data/model/user_model/user_model.dart';
import '../constant/box_key.dart';

class HiveServices {
  Future<void> init() async {
    await Hive.initFlutter();
    await _initAppBox();
    Future.wait([
      _initUser(),
    ]);
  }

  Future<void> _initUser() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<UserModel>(UserModelAdapter());
    }
    await Hive.openBox<UserModel>(BoxKey.user);
  }

  Future<void> _initAppBox() async {
    await Hive.openBox(BoxKey.appBox);
  }
}
