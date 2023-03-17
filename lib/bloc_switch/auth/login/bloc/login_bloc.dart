import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/helper_function.dart';
import '../../../../services/database_service.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginAttemptEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      AuthService authService = AuthService();

      emit(LoginLoading());

      await authService.loginUser(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          emit(LoggedIn());
        } else {
          emit(LoginError(message: value.toString()));
        }
      });

      // await authService.loginUser(email, password);
    });
    on<LoginEmailChangedEvent>((event, emit) {
      emit(LoginEssentials(email: event.email));
    });
  }
}
