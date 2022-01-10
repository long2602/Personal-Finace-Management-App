import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

//event thay đổi email
class LoginEventEmailChanged extends LoginEvent {
  final String email;
  //constructor
  LoginEventEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];

  @override
  String toString() {
    return "Email changed: $email";
  }
}

//event thay đổi password
class LoginEventPasswordChanged extends LoginEvent {
  final String password;

  //constructor
  LoginEventPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];

  @override
  String toString() {
    return "Password changed: $password";
  }
}

class LoginEventWithGooglePressed extends LoginEvent {}

//event press login
class LoginEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;

  //constructor
  LoginEventWithEmailAndPasswordPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() =>
      'LoginEventWithEmailAndPasswordPressed, email = $email, password = $password';
}
