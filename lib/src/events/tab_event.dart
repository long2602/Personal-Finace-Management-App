import 'package:equatable/equatable.dart';

abstract class TabEvent extends Equatable {
  @override
  List<Object?> get props => [];
  const TabEvent();
}

class TabEventChangeHomeTab extends TabEvent {}

class TabEventChangeWalletTab extends TabEvent {}

class TabEventChangeStatisticTab extends TabEvent {}

class TabEventChangeSettingTab extends TabEvent {}
