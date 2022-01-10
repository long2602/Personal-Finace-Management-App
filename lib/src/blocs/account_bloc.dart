import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loda_app/src/events/account_event.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/account_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository _userRepository;
  // ignore: unused_field
  final Users _user;
  AccountBloc({
    required UserRepository userRepository,
    required Users user,
  })  : _userRepository = userRepository,
        _user = user,
        super(AccountStateInitial(user));

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final id = preferences.getString("IDCURRENT")!;
    if (event is AccountEventUpdatePress) {
      await _userRepository.updateUser(event.name, event.imgPath);
      Users user = await _userRepository.getUserData(id);
      yield AccountStateLoadding(user);
      yield AccountStateUpdate(user);
    }
  }
}
