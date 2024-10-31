import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../core/constant/box_key.dart';
import '../../data/api/firebase/auth_data/auth_data.dart';
import '../../data/model/user_model/user_model.dart';
import '../../data/repository/login_repo/auth.repo.dart';
import '../../dependencies/dependencies_injection.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController screenCode = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository;
  bool obscureText = true;

  LoginCubit(this._authRepository) : super(LoginInitial());

  void toggleObscureText() {
    obscureText = !obscureText;
    emit(ToggleObscure(obscureText));
  }

  void initUser() async {
    if (getIt<Box>().get(BoxKey.adminCreated) != true) {
      emit(LoginLoading());
      var result = await _authRepository.register(
          email: "admin@gmail.com",
          name: "admin",
          password: "123456",
          role: "admin");
      result.fold((_) {}, (success) async {
        await getIt<Box>().put(BoxKey.adminCreated, true);
      });
      emit(LoginInitial());
    }
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      emit(LoginLoading());
      var result = await _authRepository.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      result.fold((error) => emit(LoginFailure(error: error.message)), (user) {
        if (user != null) {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          emit(LoginSuccess(user));
        }
      });
    }
  }

  Future<void> getUser() async {
    var result =
        await getIt<AuthData>().getUser(screenId: screenCode.text.trim());
    result.fold((error) => emit(LoginFailure(error: error.message)), (userId) {
      if (userId != null) {
        emit(LoginSuccessToScreen(userId, screenCode.text.trim()));
      }
    });
  }

  Future<void> register() async {
    if (formKey.currentState?.validate() ?? false) {
      emit(LoginLoading());
      var result = await _authRepository.register(
          email: emailController.text.trim(),
          password: "123456",
          name: nameController.text.trim(),
          role: 'user');
      result.fold((error) => emit(LoginFailure(error: error.message)), (user) {
        if (user != null) {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          emit(LoginSuccessRegister(user));
        }
      });
    }
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    return super.close();
  }
}
