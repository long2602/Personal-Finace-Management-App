import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountEventUpdatePress extends AccountEvent {
  final String imgPath;
  final String name;
  AccountEventUpdatePress({
    required this.imgPath,
    required this.name,
  });

  @override
  List<Object?> get props => [imgPath, name];
}
