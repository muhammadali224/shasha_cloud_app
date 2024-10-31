part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class ToggleObscure extends LoginState {
  final bool isObscure;

  ToggleObscure(this.isObscure);
}

class LoginSuccess extends LoginState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginSuccessToScreen extends LoginState {
  final String userId;
  final String screenId;

  LoginSuccessToScreen(this.userId, this.screenId);
}

class LoginSuccessRegister extends LoginState {
  final UserModel user;

  LoginSuccessRegister(this.user);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
