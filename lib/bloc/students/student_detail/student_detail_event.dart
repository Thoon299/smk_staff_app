import 'package:equatable/equatable.dart';

abstract class StudentDetailEvent extends Equatable{
  const StudentDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentDetail extends StudentDetailEvent{
  String student_id;
  FetchStudentDetail({required this.student_id});
}

class FetchStudentDetailForAllClass extends StudentDetailEvent{
  String student_id;
  FetchStudentDetailForAllClass({required this.student_id});
}