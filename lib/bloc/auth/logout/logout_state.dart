import 'package:equatable/equatable.dart';
import 'package:smk/models/logoutReplyModel.dart';

abstract class LogoutState extends Equatable{
  @override
  List<Object> get props => [];
}

class LogoutEmpty extends LogoutState{}


class LogoutLoading extends LogoutState{}

class LogoutLoaded extends LogoutState{
  final LogoutReplyModel logoutReplyModel;
  LogoutLoaded({required this.logoutReplyModel});
}

class LogoutError extends LogoutState{
  final String errorMessage;
  LogoutError({required this.errorMessage});
}