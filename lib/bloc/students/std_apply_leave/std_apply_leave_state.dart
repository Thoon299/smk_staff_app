import 'package:equatable/equatable.dart';
import 'package:smk/models/student_attendence_marking/student_attendence_marking_model.dart';

import '../../../models/std_apply_leave/std_apply_leave_model.dart';
import '../../../models/std_apply_leave/std_apply_leave_status_model.dart';


abstract class StdApplyLeaveState extends Equatable{
  @override
  List<Object> get props => [];
}

class StdApplyLeaveEmpty extends StdApplyLeaveState{}

class StdApplyLeaveLoading extends StdApplyLeaveState{}

class StdApplyLeaveLoaded extends StdApplyLeaveState{
  final StdApplyLeaveModel stdApplyLeaveModel;
  StdApplyLeaveLoaded({required this.stdApplyLeaveModel});
}

class StdApplyLeaveError extends StdApplyLeaveState{
  final String errorMessage;
  StdApplyLeaveError({required this.errorMessage});
}

//update status
class StdApplyLeaveStatusLoading extends StdApplyLeaveState{}

class StdApplyLeaveStatusLoaded extends StdApplyLeaveState{
  final StdApplyLeaveStatusModel stdApplyLeaveStatusModel;
  StdApplyLeaveStatusLoaded({required this.stdApplyLeaveStatusModel});
}

class StdApplyLeaveStatusError extends StdApplyLeaveState{
  final String errorMessage;
  StdApplyLeaveStatusError({required this.errorMessage});
}