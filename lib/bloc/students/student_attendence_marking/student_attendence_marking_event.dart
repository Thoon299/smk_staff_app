import 'package:equatable/equatable.dart';

abstract class StudentAttendenceMarkingEvent extends Equatable{
  const StudentAttendenceMarkingEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentAttendenceMarking extends StudentAttendenceMarkingEvent{
  String class_id;
  String session_id;String date;
  FetchStudentAttendenceMarking({required this.class_id,required this.session_id,required this.date});
}