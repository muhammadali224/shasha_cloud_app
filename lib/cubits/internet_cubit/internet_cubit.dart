import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/enum/internet.enum.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(const InternetState(ConnectivityEnum.disconnected)) {
    _initializeConnectivity();
  }

  void _initializeConnectivity() async {
    var connectionResult = await Connectivity().checkConnectivity();
    _updateConnectionState(connectionResult);
    traceConnectivityChange();
  }

  void _updateConnectionState(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      emit(const InternetState(ConnectivityEnum.disconnected));
    } else if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      emit(const InternetState(ConnectivityEnum.connected));
    }
  }

  late StreamSubscription<List<ConnectivityResult>?> _subscription;

  void traceConnectivityChange() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionState(result);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
