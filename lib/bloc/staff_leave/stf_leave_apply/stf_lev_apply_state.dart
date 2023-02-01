import 'package:equatable/equatable.dart';

abstract class StfLevApplyState extends Equatable{
  @override
  List<Object> get props => [];
}

class StfLevApplyInitialize extends StfLevApplyState{}

class StfLevApplyLoading extends StfLevApplyState{}

class StfLevApplyLoaded extends StfLevApplyState{
  String success;
  StfLevApplyLoaded({required this.success});
}

class StfLevApplyError extends StfLevApplyState{
  final String errorMessage;
  StfLevApplyError({required this.errorMessage});
}
