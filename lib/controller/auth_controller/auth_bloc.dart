import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/auth_controller/auth_event.dart';
import 'package:live_streaming/controller/auth_controller/auth_state.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:logger/logger.dart';

class AuthBloc extends Bloc<LoginEvent, LoginState> {
  static final _logger = Logger();
  final _authservice = Locator<AuthService>();
  AuthBloc() : super(const LoginInitialState()) {
    on<LoginWithGoogleEvent>(
      (_, emit) async {
        if (state is LoginLoadingState) return;
        emit(const LoginLoadingState());
        final result = await _authservice.loginWithGoogle();
        if (result.hasError) {
          _logger.e(result.error?.stackTrace);
          emit(LoginErrorState(result.error?.messsage));
          return;
        }

        emit(const LoginSucessState());
      },
    );
  }
}
