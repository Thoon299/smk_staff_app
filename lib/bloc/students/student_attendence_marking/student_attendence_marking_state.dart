import 'package:equatable/equatable.dart';
import 'package:smk/models/student_attendence_marking/student_attendence_marking_model.dart';
import 'package:smk/models/students/student_list_model.dart';

import '../../../models/students/student_home_model.dart';


abstract class StudentAttendenceMarkingState extends Equatable{
  @override
  List<Object> get props => [];
}

class StudentAttendenceMarkingEmpty extends StudentAttendenceMarkingState{}

class StudentAttendenceMarkingLoading extends StudentAttendenceMarkingState{}

class StudentAttendenceMarkingLoaded extends StudentAttendenceMarkingState{
  final StudentAttendenceMarkingModel studentAttendenceMarkingModel;
  StudentAttendenceMarkingLoaded({required this.studentAttendenceMarkingModel});
}

class StudentAttendenceMarkingError extends StudentAttendenceMarkingState{
  final String errorMessage;
  StudentAttendenceMarkingError({required this.errorMessage});
}