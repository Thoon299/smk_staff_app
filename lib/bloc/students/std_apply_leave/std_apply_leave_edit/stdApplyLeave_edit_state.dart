import 'package:equatable/equatable.dart';

abstract class StdApplyLeaveEditState extends Equatable{
  @override
  List<Object> get props => [];
}

class StdApplyLeaveEditInitialize extends StdApplyLeaveEditState{}

class StdApplyLeaveEditLoading extends StdApplyLeaveEditState{}

class StdApplyLeaveEditLoaded extends StdApplyLeaveEditState{
  String success;
  StdApplyLeaveEditLoaded({required this.success});
}
class StdApplyLeaveEditError extends StdApplyLeaveEditState{
  final String errorMessage;
  StdApplyLeaveEditError({required this.errorMessage});
}
