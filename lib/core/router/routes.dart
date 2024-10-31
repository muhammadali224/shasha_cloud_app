import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../data/model/user_model/user_model.dart';
import '../../dependencies/dependencies_injection.dart';
import '../../view/screen/client_details/client_details_screen.dart';
import '../../view/screen/client_slider/client_slider.dart';
import '../../view/screen/home/home_screen.dart';
import '../../view/screen/login/login_screen.dart';
import '../../view/screen/screen_gallery/screen_gallery.dart';
import '../constant/box_key.dart';
import '../constant/routes.dart';
import '../context/global.dart';

final goRouter = GoRouter(
  navigatorKey: GlobalContext.navigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: AppRoutes.root,
        redirect: (context, state) async {
          final user = getIt<Box<UserModel>>().get(BoxKey.user);

          if (user != null) {
            if (user.role == "admin") {
              return AppRoutes.home;
            } else {
              return AppRoutes.clientDetails;
            }
          } else {
            final String? step = await getIt<Box>().get(BoxKey.step);
            if (step == "1") {
              return AppRoutes.clientHome;
            }
            return AppRoutes.login;
          }
        }),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
    GoRoute(
        path: AppRoutes.clientDetails,
        builder: (_, __) => const ClientDetailsScreen()),
    GoRoute(
        path: AppRoutes.screenGallery,
        builder: (_, __) => const ScreenGallery()),
    GoRoute(
        path: AppRoutes.clientHome, builder: (_, __) => const ClientSlider()),
  ],
);
