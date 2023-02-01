import 'package:equatable/equatable.dart';

abstract class NewState extends Equatable{
  @override
  List<Object> get props => [];
}

class NewInitialize extends NewState{}

class NewLoading extends NewState{}

class NewLoaded extends NewState{
  String success;
  NewLoaded({required this.success});
}

class NewError extends NewState{
  final String errorMessage;
  NewError({required this.errorMessage});
}
