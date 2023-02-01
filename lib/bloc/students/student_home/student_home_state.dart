import 'package:equatable/equatable.dart';

import '../../../models/students/student_home_model.dart';


abstract class StudentHomeState extends Equatable{
  @override
  List<Object> get props => [];
}

class StudentHomeEmpty extends StudentHomeState{}

class StudentHomeLoading extends StudentHomeState{}

class StudentHomeLoaded extends StudentHomeState{
  final StudentHome aList;
  StudentHomeLoaded({required this.aList});
}

class StudentHomeError extends StudentHomeState{
  final String errorMessage;
  StudentHomeError({required this.errorMessage});
}