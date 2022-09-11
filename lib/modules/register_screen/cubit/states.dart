

abstract class RegisterStates {}
class RegisterIntialState extends RegisterStates {}
class ChangeSuffixState extends RegisterStates {}
class RegisterLoadingState extends RegisterStates {}
class RegisterSuccessState extends RegisterStates {}
class CreateUserSuccessState extends RegisterStates {}
class CreateUserErrorState extends RegisterStates {
  String error;
  CreateUserErrorState(this.error);
}
class RegisterErrorState extends RegisterStates {
  String error;
  RegisterErrorState(this.error);
}