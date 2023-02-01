import 'package:equatable/equatable.dart';

abstract class StudentListEvent extends Equatable{
  const StudentListEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentList extends StudentListEvent{
  String class_id;
  String section_id;String search;
  FetchStudentList({required this.class_id,required this.section_id,required this.search});
}


class FetchStudentListForAllClass extends StudentListEvent{
  String search;
  FetchStudentListForAllClass({required this.search});
}