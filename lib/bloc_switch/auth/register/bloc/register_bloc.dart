import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/helper_function.dart';
import '../../../../services/auth_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterAttemptEvent>((event, emit) async {
      final fullName = event.fullName;
      final email = event.email;
      final pw = event.password;
      AuthService authService = AuthService();

      emit(RegisterLoading());

      await authService.registerUser(fullName, email, pw).then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          emit(RegisterSuccess());
        } else {
          emit(RegisterError(error: value.toString()));
        }
      });
    });
  }
}
