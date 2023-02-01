import 'package:equatable/equatable.dart';
import 'package:smk/models/students/student_list_model.dart';

import '../../../models/students/student_detail_forallclass_model.dart';
import '../../../models/students/student_detail_model.dart';
import '../../../models/students/student_home_model.dart';
import '../../../ui/students/student_detail.dart';


abstract class StudentDetailState extends Equatable{
  @override
  List<Object> get props => [];
}

class StudentDetailEmpty extends StudentDetailState{}

class StudentDetailLoading extends StudentDetailState{}

class StudentDetailLoaded extends StudentDetailState{
  final StudentDetailModel aList;
  StudentDetailLoaded({required this.aList});
}

class StudentDetailError extends StudentDetailState{
  final String errorMessage;
  StudentDetailError({required this.errorMessage});
}

//for all class detail student

class StudentDetailForAllClassLoading extends StudentDetailState{}

class StudentDetailForAllClassLoaded extends StudentDetailState{
  final StudentDetailForAllClassModel studentDetailForAllClassModel;
  StudentDetailForAllClassLoaded({required this.studentDetailForAllClassModel});
}

class StudentDetailForAllClassError extends StudentDetailState{
  final String errorMessage;
  StudentDetailForAllClassError({required this.errorMessage});
}