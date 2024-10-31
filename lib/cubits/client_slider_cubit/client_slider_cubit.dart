// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../core/errors/failure.dart';
// import '../../data/model/media_model/media_model.dart';
// import '../../data/model/user_model/user_model.dart';
// import '../../data/repository/client_repo/client.repo.dart';
//
// part 'client_slider_state.dart';
//
// class ClientSliderCubit extends Cubit<ClientSliderState> {
//   final ClientRepository _clientRepository;
//   StreamSubscription<Either<Failure, UserModel>>? _clientSubscription;
//
//
//   ClientSliderCubit(this._clientRepository) : super(ClientSliderInitial());
//
//   // void getClientsAsStream(String id) {
//   //   emit(ClientSliderLoading());
//   //
//   //   _clientSubscription?.cancel();
//   //
//   //   _clientSubscription =
//   //       _clientRepository.getClientStream(id: id).listen((result) {
//   //     result.fold(
//   //       (failure) => emit(ClientSliderError(failure.message)),
//   //       (client) {
//   //         emit(ClientSliderSuccess(client));
//   //       },
//   //     );
//   //   });
//   // }
//
//
//   @override
//   Future<void> close() {
//     _clientSubscription?.cancel();
//
//     return super.close();
//   }
// }
