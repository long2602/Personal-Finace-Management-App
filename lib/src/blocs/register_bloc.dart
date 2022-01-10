// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/register_event.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/register_state.dart';
import 'package:loda_app/src/validators/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> events,
      TransitionFunction<RegisterEvent, RegisterState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEventEmailChanged &&
          event is! RegisterEventPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEventEmailChanged ||
          event is RegisterEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEventEmailChanged) {
      yield state.cloneAndUpdate(
          isValidEmail: isValidator.isValidEmail(event.email));
    } else if (event is RegisterEventPasswordChanged) {
      yield state.cloneAndUpdate(
          isValidPassword: isValidator.isValidPassword(event.password));
    } else if (event is RegisterEventCheckPassAndConfirmPass) {
      yield state.cloneAndUpdate(
          isVaidConfirmPassword:
              isValidator.isValidConfirmPassword(event.pass, event.rePass));
    } else if (event is RegisterEventNameChanged) {
      yield state.cloneAndUpdate(
          isValidName: isValidator.isValidName(event.name));
    } else if (event is RegisterEventPressed) {
      try {
        if (isValidator.isValidEmail(event.email) &&
            isValidator.isValidPassword(event.password) &&
            isValidator.isValidConfirmPassword(
                event.password, event.confirmPassword) &&
            isValidator.isValidName(event.name)) {
          try {
            final uid = await _userRepository.createUserWithEmailAndPassword(
                event.email, event.password);
            await _userRepository.insertUser(uid, event.name, event.email);
            await _userRepository.insertGeneralWallet(
                "General", "0", "", "VNĐ", AppUI.wallet1, uid);
            yield RegisterState.success();
          } catch (e) {
            yield RegisterState.failure();
          }
        } else {
          bool email = true, name = true, pass = true, repass = true;
          if (isValidator.isValidEmail(event.email) == false) {
            email = false;
          }
          if (isValidator.isValidPassword(event.password) == false) {
            pass = false;
          }
          if (isValidator.isValidConfirmPassword(
                  event.password, event.confirmPassword) ==
              false) {
            repass = false;
          }
          if (isValidator.isValidName(event.name) == false) {
            name = false;
          }
          yield state.cloneAndUpdate(
              isValidEmail: email,
              isValidName: name,
              isValidPassword: pass,
              isVaidConfirmPassword: repass);
        }
      } catch (_) {
        yield RegisterState.failure();
      }
    }
  }
}
