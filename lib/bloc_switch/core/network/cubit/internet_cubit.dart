import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/bloc_switch/core/constants/enum.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;
  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  void monitorInternetConnection() {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (event == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (event == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));
  void emitInternetDisconnected() => emit(InternetDisconnected());
  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
