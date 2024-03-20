abstract class LoginState {
  const LoginState();
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginSucessState extends LoginState {
  const LoginSucessState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginErrorState extends LoginState {
  final String? message;
  const LoginErrorState(this.message);
}
