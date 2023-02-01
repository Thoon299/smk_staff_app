
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
  @override
  List<Object> get props=>[];
}

class LoginStart extends LoginEvent {
}

class LoginPressedButton extends LoginEvent {
  String email;
  String deviceToken;
  String password;
  String oldFcmToken;

  LoginPressedButton({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.oldFcmToken,
  });
}