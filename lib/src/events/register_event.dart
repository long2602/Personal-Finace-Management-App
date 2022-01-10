import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEventEmailChanged extends RegisterEvent {
  final String email;
  RegisterEventEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'RegisterEventEmailChanged, email :$email';
}

class RegisterEventPasswordChanged extends RegisterEvent {
  final String password;

  RegisterEventPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterEventPasswordChanged, password: $password';
}

class RegisterEventConfirmPasswordChanged extends RegisterEvent {
  final String password;

  RegisterEventConfirmPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() =>
      'RegisterEventConfirmPasswordChanged, password: $password';
}

class RegisterEventNameChanged extends RegisterEvent {
  final String name;

  RegisterEventNameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'RegisterEventNameChanged, password: $name';
}

class RegisterEventCheckPassAndConfirmPass extends RegisterEvent {
  final String pass;
  final String rePass;
  RegisterEventCheckPassAndConfirmPass({
    required this.pass,
    required this.rePass,
  });

  @override
  List<Object> get props => [pass, rePass];
}

class RegisterEventPressed extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;

  RegisterEventPressed({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, name];

  @override
  String toString() {
    return 'RegisterEventPressed, email: $email, password: $password';
  }
}
