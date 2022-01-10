// enum TabState { HOME, WALLET, STATISTIC, SETTING }

import 'package:equatable/equatable.dart';

import 'package:loda_app/src/models/user.dart';

class TabState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TabInitialState extends TabState {}

class TabHomeState extends TabState {
  final Users users;
  final Map<String, dynamic> wallet;
  TabHomeState({
    required this.users,
    required this.wallet,
  });

  @override
  List<Object?> get props => [users, wallet];
}

class TabWalletState extends TabState {
  final Users users;
  final Map<String, dynamic> wallet;
  TabWalletState({
    required this.users,
    required this.wallet,
  });

  @override
  List<Object?> get props => [users, wallet];
}

class TabStatisticState extends TabState {
  final Users users;
  final Map<String, dynamic> wallet;
  TabStatisticState({
    required this.users,
    required this.wallet,
  });

  @override
  List<Object?> get props => [users, wallet];
}

class TabSettingState extends TabState {
  final Users users;

  TabSettingState({
    required this.users,
  });

  @override
  List<Object?> get props => [users];
}
