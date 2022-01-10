import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/tab_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  final UserRepository _userRepository;

  TabBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(TabInitialState());

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final id = preferences.getString("IDCURRENT")!;
    if (event is TabEventChangeHomeTab) {
      late Map<String, dynamic> _wallet;
      final results = await Future.wait([
        _userRepository.getUserData(id),
        _userRepository.getSelectedWallet(),
      ]);
      Users user = results[0] as Users;
      final data = results[1] as QuerySnapshot;
      data.docs.forEach((element) {
        _wallet = element.data() as Map<String, dynamic>;
        _wallet['id'] = element.id;
      });
      yield TabHomeState(users: user, wallet: _wallet);
    } else if (event is TabEventChangeWalletTab) {
      late Map<String, dynamic> _wallet;
      final results = await Future.wait([
        _userRepository.getUserData(id),
        _userRepository.getSelectedWallet(),
      ]);
      Users user = results[0] as Users;
      final data = results[1] as QuerySnapshot;
      data.docs.forEach((element) {
        _wallet = element.data() as Map<String, dynamic>;
        _wallet['id'] = element.id;
      });
      yield TabWalletState(users: user, wallet: _wallet);
    } else if (event is TabEventChangeStatisticTab) {
      late Map<String, dynamic> _wallet;
      final results = await Future.wait([
        _userRepository.getUserData(id),
        _userRepository.getSelectedWallet(),
      ]);
      Users user = results[0] as Users;
      final data = results[1] as QuerySnapshot;
      data.docs.forEach((element) {
        _wallet = element.data() as Map<String, dynamic>;
        _wallet['id'] = element.id;
      });
      yield TabStatisticState(users: user, wallet: _wallet);
    } else if (event is TabEventChangeSettingTab) {
      Users user = await _userRepository.getUserData(id);
      yield TabSettingState(users: user);
    }
  }
}
