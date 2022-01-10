import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isValidConfirmPassword;
  final bool isValidName;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  RegisterState({
    required this.isValidEmail,
    required this.isValidPassword,
    required this.isValidConfirmPassword,
    required this.isValidName,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  factory RegisterState.initial() {
    return RegisterState(
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isValidName: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isValidName: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isValidName: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isValidName: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool? isValidEmail,
    bool? isValidPassword,
    bool? isValidConfirmPassword,
    bool? isValidName,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return RegisterState(
      isValidEmail: isValidEmail ?? this.isValidEmail,
      isValidPassword: isValidPassword ?? this.isValidPassword,
      isValidConfirmPassword:
          isValidConfirmPassword ?? this.isValidConfirmPassword,
      isValidName: isValidName ?? this.isValidName,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  RegisterState cloneAndUpdate({
    bool? isValidEmail,
    bool? isValidPassword,
    bool? isVaidConfirmPassword,
    bool? isValidName,
  }) {
    return copyWith(
      isValidEmail: isValidEmail ?? this.isValidEmail,
      isValidPassword: isValidPassword ?? this.isValidPassword,
      isValidConfirmPassword:
          isVaidConfirmPassword ?? this.isValidConfirmPassword,
      isValidName: isValidName ?? this.isValidName,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
}
