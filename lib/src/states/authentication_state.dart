import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

//state khởi tạo
class AuthenticationStateInitial extends AuthenticationState {}

//success state
class AuthenticationStateSuccess extends AuthenticationState {
  final User user;
  AuthenticationStateSuccess({
    required this.user,
  });

  @override
  List<Object?> get props => [user];

  @override
  String toString() {
    return "success: $user";
  }
}

//failure state
class AutheticationStateFailure extends AuthenticationState {}
