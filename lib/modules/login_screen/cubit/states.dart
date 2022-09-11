

abstract class LoginStates {}
class LoginIntialState extends LoginStates {}
class ChangeSuffixState extends LoginStates {}
class LoginLoadingState extends LoginStates {}
class LoginSuccessState extends LoginStates {}
class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState(this.error);
}
class CreateUserLoginSuccessState extends LoginStates {}
class CreateUserLoginErrorState extends LoginStates {
  String error;
  CreateUserLoginErrorState(this.error);
}
class GetUserLoginLoadingState extends LoginStates {}
class GetUserLoginSuccessState extends LoginStates {}
class GetUserLoginErrorState extends LoginStates {
  String error;
  GetUserLoginErrorState(this.error);
}