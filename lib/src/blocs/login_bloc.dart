// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loda_app/src/events/login_event.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/login_state.dart';
import 'package:loda_app/src/validators/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  //constructor
  LoginBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFunction) {
    final debounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChanged ||
          loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300)); //minimum 300ms for each event
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged &&
          loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEventEmailChanged) {
      yield state.cloneAndUpdate(
          isValidEmail: isValidator.isValidEmail(event.email));
    } else if (event is LoginEventPasswordChanged) {
      yield state.cloneAndUpdate(
          isValidPassword: isValidator.isValidPassword(event.password));
    } else if (event is LoginEventWithEmailAndPasswordPressed) {
      try {
        if (isValidator.isValidEmail(event.email) &&
            isValidator.isValidPassword(event.password)) {
          try {
            final check = await _userRepository.signInWithEmailAndPassword(
                event.email, event.password);
            if (check == true) {
              yield LoginState.success();
            } else {
              yield LoginState.failure();
            }
          } catch (_) {
            yield LoginState.failure();
          }
        } else {
          if (isValidator.isValidEmail(event.email) == false &&
              isValidator.isValidPassword(event.password) == false) {
            yield state.cloneAndUpdate(
                isValidEmail: isValidator.isValidEmail(event.email),
                isValidPassword: isValidator.isValidPassword(event.password));
          } else if (isValidator.isValidEmail(event.email) == false &&
              isValidator.isValidPassword(event.password) == true) {
            yield state.cloneAndUpdate(
                isValidEmail: isValidator.isValidEmail(event.email));
          } else if (isValidator.isValidEmail(event.email) == true &&
              isValidator.isValidPassword(event.password) == false) {
            yield state.cloneAndUpdate(
                isValidEmail: isValidator.isValidPassword(event.password));
          }
        }
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
