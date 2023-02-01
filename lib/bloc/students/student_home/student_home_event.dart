import 'package:equatable/equatable.dart';

abstract class StudentHomeEvent extends Equatable{
  const StudentHomeEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentHome extends StudentHomeEvent{
  String search;
  FetchStudentHome({required this.search});
}