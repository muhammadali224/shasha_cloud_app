import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../core/constant/app_strings.dart';
import '../../../core/constant/box_key.dart';
import '../../../cubits/client_cubit/client_cubit.dart';
import '../../../cubits/login_cubit/login_cubit.dart';
import '../../../data/api/firebase/auth_data/auth_data.dart';
import '../../../data/api/firebase/client_data/client_data.dart';
import '../../../data/model/user_model/user_model.dart';
import '../../../dependencies/dependencies_injection.dart';
import 'widget/client_details_appbar.dart';
import 'widget/client_details_body.dart';

class ClientDetailsScreen extends StatelessWidget {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? id = GoRouterState.of(context).extra as String?;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(AppStrings.home.tr()),
        actions: [
          if (id == null)
            BlocProvider(
              create: (context) => LoginCubit(getIt<AuthData>()),
              child: const ClientDetailsAppbar(),
            ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ClientCubit(getIt<ClientData>())
          ..getClientsAsStream(
              id ?? getIt<Box<UserModel>>().get(BoxKey.user)!.id),
        child: ClientDetailsBody(
            id: id ?? getIt<Box<UserModel>>().get(BoxKey.user)!.id),
      ),
    );
  }
}
