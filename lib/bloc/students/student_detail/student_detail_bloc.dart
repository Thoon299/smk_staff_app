import 'package:bloc/bloc.dart';
import 'package:smk/bloc/students/student_detail/student_detail_event.dart';
import 'package:smk/bloc/students/student_detail/student_detail_state.dart';
import 'package:smk/models/students/student_detail_model.dart';

import '../../../data/repository/student_repository.dart';
import '../../../models/students/student_detail_forallclass_model.dart';


class StudentDetailBloc extends Bloc<StudentDetailEvent,StudentDetailState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StudentRepository studentRepository;
  StudentDetailBloc(this.studentRepository) : super(StudentDetailEmpty());



  @override
  Stream<StudentDetailState> mapEventToState(
      StudentDetailEvent event
      ) async*{
    if(event is FetchStudentDetail){
      yield StudentDetailLoading();
      try{
        StudentDetailModel aList = await studentRepository.getStudentDetail(event.student_id);
        yield StudentDetailLoaded(aList: aList);
      }
      catch (e){
        yield StudentDetailError(errorMessage: e.toString());
      }
    }

    else if(event is FetchStudentDetailForAllClass){
      yield StudentDetailForAllClassLoading();
      try{
        StudentDetailForAllClassModel studentDetailForAllClassModel = await studentRepository.getStudentDetailForAllClass(event.student_id);
        yield StudentDetailForAllClassLoaded(studentDetailForAllClassModel: studentDetailForAllClassModel);
      }
      catch (e){
        yield StudentDetailForAllClassError(errorMessage: e.toString());
      }
    }
  }
}