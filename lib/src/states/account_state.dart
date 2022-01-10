import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:loda_app/src/models/user.dart';

@immutable
class AccountState extends Equatable {
  final Users user;

  AccountState(this.user);
  @override
  List<Object?> get props => [];
}

class AccountStateInitial extends AccountState {
  final Users user;
  AccountStateInitial(this.user) : super(user);
}

class AccountStateUpdate extends AccountState {
  final Users user;
  AccountStateUpdate(this.user) : super(user);
}

class AccountStateLoadding extends AccountState {
  AccountStateLoadding(Users user) : super(user);
}
