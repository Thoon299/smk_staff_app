import 'package:equatable/equatable.dart';
import 'package:smk/models/students/student_list_model.dart';

import '../../../models/students/student_home_model.dart';
import '../../../models/students/students_list_forallclass_model.dart';


abstract class StudentListState extends Equatable{
  @override
  List<Object> get props => [];
}

class StudentListEmpty extends StudentListState{}

class StudentListLoading extends StudentListState{}

class StudentListLoaded extends StudentListState{
  final StudentList aList;
  StudentListLoaded({required this.aList});
}

class StudentListError extends StudentListState{
  final String errorMessage;
  StudentListError({required this.errorMessage});
}

//for all class
class StudentListForAllClassLoading extends StudentListState{}

class StudentListForAllClassLoaded extends StudentListState{
  final StudentListForAllClassModel studentListForAllClass;
  StudentListForAllClassLoaded({required this.studentListForAllClass});
}

class StudentListForAllClassError extends StudentListState{
  final String errorMessage;
  StudentListForAllClassError({required this.errorMessage});
}