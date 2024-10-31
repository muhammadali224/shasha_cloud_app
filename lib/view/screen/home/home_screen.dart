import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_strings.dart';
import '../../../cubits/home_cubit/home_cubit.dart';
import '../../../cubits/login_cubit/login_cubit.dart';
import '../../../data/api/firebase/auth_data/auth_data.dart';
import '../../../data/api/firebase/client_data/client_data.dart';
import '../../../dependencies/dependencies_injection.dart';
import 'widget/app_bar_menu_action.dart';
import 'widget/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.the.tr(args: [AppStrings.clients.tr()])),
        actions: [
          BlocProvider(
            create: (context) => LoginCubit(getIt<AuthData>()),
            child: AppBarMenuAction(),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            HomeCubit(getIt<ClientData>())..getClientsAsStream(),
        child: const HomeBody(),
      ),
    );
  }
}
