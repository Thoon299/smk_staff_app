import 'package:equatable/equatable.dart';

abstract class LogoutEvent extends Equatable{
  const LogoutEvent();

  @override
  List<Object> get props => [];
}



class FetchLogout extends LogoutEvent{
  String fcm_token;
  FetchLogout({required this.fcm_token});
}