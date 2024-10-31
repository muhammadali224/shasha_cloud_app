import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:logger/logger.dart';

import 'core/bloc/observer/block_observer.dart';
import 'core/localization/localization.dart';
import 'core/router/routes.dart';
import 'core/services/app.service.dart';
import 'core/services/hive.service.dart';
import 'cubits/client_cubit/client_cubit.dart';
import 'cubits/internet_cubit/internet_cubit.dart';
import 'cubits/localization_cubit/localization.cubit.dart';
import 'cubits/notifications_cubit/notifications_cubit.dart';
import 'cubits/theme_cubit/theme.cubit.dart';
import 'data/api/firebase/client_data/client_data.dart';
import 'dependencies/dependencies_injection.dart';

var logger = Logger(
  printer: PrettyPrinter(
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveServices().init();

  await AppServices().initAppServices();
  await initGetIt();
  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', ""),
        Locale('ar', ""),
      ],
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      path: '/',
      assetLoader: CodeAssetLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => InternetCubit()..traceConnectivityChange()),
        BlocProvider(create: (_) => NotificationsCubit()),
        BlocProvider(create: (_) => ClientCubit(getIt<ClientData>())),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          context
              .read<ThemeCubit>()
              .updateTheme(locale: locale, isDarkMode: false);
          return ScreenUtilInit(
            builder: (_, child) {
              return BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, theme) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    theme: theme,
                    routerConfig: goRouter,
                    builder: FlutterSmartDialog.init(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
