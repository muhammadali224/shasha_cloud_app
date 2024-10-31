import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../core/errors/failure.dart';
import '../../data/model/user_model/user_model.dart';
import '../../data/repository/client_repo/client.repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ClientRepository _clientRepository;
  StreamSubscription<Either<Failure, List<UserModel>>>? _clientSubscription;

  HomeCubit(this._clientRepository) : super(HomeInitial());

  void getClientsAsStream() {
    emit(HomeLoading());

    _clientSubscription?.cancel();

    _clientSubscription =
        _clientRepository.getClientsAsStream().listen((result) {
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (clients) => emit(HomeLoaded(clients)),
      );
    });
  }

  @override
  Future<void> close() {
    _clientSubscription?.cancel();
    return super.close();
  }
}
