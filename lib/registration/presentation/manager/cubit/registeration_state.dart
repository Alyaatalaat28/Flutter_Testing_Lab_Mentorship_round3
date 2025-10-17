part of 'registeration_cubit.dart';

@immutable
sealed class RegisterationState {}

final class RegisterationInitial extends RegisterationState {}

final class RegisterationLoading extends RegisterationState {}

final class RegisterationSuccess extends RegisterationState {
  final String successMessage;

  RegisterationSuccess(this.successMessage);
}

final class RegisterationFailure extends RegisterationState {
  final String errMessage;

  RegisterationFailure(this.errMessage);
}
