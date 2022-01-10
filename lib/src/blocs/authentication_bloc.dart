import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loda_app/src/events/authentication_event.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/authentication_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationStateInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationEventStarted) {
      // final isSignedIn = await _userRepository.isSignedIn();
      //kiểm tra đăng nhập chưa
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? id = preferences.getString("IDCURRENT");
      if (id != null) {
        //lấy user và trả về cho state success
        final user = await _userRepository.getUser();

        yield AuthenticationStateSuccess(user: user);
      } else {
        yield AutheticationStateFailure();
      }
    } else if (event is AuthenticationEventLoggedIn)

    ///đang đăng nhập
    {
      yield AuthenticationStateSuccess(user: await _userRepository.getUser());
    } else if (event is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('IDCURRENT');
      yield AutheticationStateFailure();
    }
  }
}
