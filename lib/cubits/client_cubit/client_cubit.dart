import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../core/errors/failure.dart';
import '../../data/repository/client_repo/client.repo.dart';
import '../../main.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepository _clientRepository;

  StreamSubscription<Either<Failure, List<Map<String, dynamic>>>>?
      _clientSubscription;

  ClientCubit(this._clientRepository) : super(ClientInitial());

  getClientsAsStream(String id) {
    emit(ClientLoading());

    _clientSubscription?.cancel();

    _clientSubscription =
        _clientRepository.getClientStream(id: id).listen((result) {
      result.fold(
        (failure) => emit(ClientError(failure.message)),
        (clientData) {
          logger.e(clientData);

          emit(ClientSuccess(clientData));
        },
      );
    });
  }

  Future<void> addClientScreen(String id) async {
    var result = await _clientRepository.addClientScreen(id);
    result.fold((error) => emit(ClientError(error.message)), (success) {});
  }

  Future<void> deleteClientScreen(String id, String screenId) async {
    var result = await _clientRepository.deleteClientScreen(
        userId: id, screenId: screenId);
    result.fold((error) => emit(ClientError(error.message)), (success) {});
  }

  @override
  Future<void> close() {
    _clientSubscription?.cancel();
    return super.close();
  }
}
