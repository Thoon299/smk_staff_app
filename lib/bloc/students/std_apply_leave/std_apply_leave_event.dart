import 'package:equatable/equatable.dart';

abstract class StdApplyLeaveEvent extends Equatable{
  const StdApplyLeaveEvent();

  @override
  List<Object> get props => [];
}

class FetchStdApplyLeave extends StdApplyLeaveEvent{
  String date;String id;
  FetchStdApplyLeave({required this.date, required this.id});
}

class UpdateStdApplyLeaveStatus extends StdApplyLeaveEvent{
  String student_applyleave_id;
  String status;
  UpdateStdApplyLeaveStatus({required this.student_applyleave_id, required this.status});
}