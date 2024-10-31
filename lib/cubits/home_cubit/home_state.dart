part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<UserModel> clients;

  HomeLoaded(this.clients);
}

final class HomeError extends HomeState {
  final String errorMessage;

  HomeError(this.errorMessage);
}
