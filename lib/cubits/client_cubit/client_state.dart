part of 'client_cubit.dart';

@immutable
sealed class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientSuccess extends ClientState {
  final List<Map<String, dynamic>> clientData;

  ClientSuccess(this.clientData);
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);
}
