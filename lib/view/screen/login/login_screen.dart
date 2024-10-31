import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/login_cubit/login_cubit.dart';
import '../../../data/api/firebase/auth_data/auth_data.dart';
import '../../../dependencies/dependencies_injection.dart';
import 'widget/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(getIt<AuthData>())..initUser(),
        child: LoginBody(),
      ),
    );
  }
}
