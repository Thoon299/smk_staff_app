import 'package:equatable/equatable.dart';

abstract class StdApplyLeaveEditEvent extends Equatable{
  const StdApplyLeaveEditEvent();

  @override
  List<Object> get props => [];
}

class StdApplyLeaveEditStart extends StdApplyLeaveEditEvent{}

class FormStdApplyLeaveEdit extends StdApplyLeaveEditEvent{
  String student_applyleave_id;
  String from_date;
  String to_date;
  String apply_date; String reason;

  FormStdApplyLeaveEdit({required this.student_applyleave_id,
    required this.from_date, required this.to_date, required this.apply_date, required this.reason});
}

