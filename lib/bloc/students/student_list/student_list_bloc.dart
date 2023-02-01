import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/students/student_list/student_list_event.dart';
import 'package:smk/bloc/students/student_list/student_list_state.dart';
import 'package:smk/models/students/students_list_forallclass_model.dart';
import '../../../data/repository/student_repository.dart';
import '../../../models/students/student_list_model.dart';




class StudentListBloc extends Bloc<StudentListEvent,StudentListState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StudentRepository studentRepository;
  StudentListBloc(this.studentRepository) : super(StudentListEmpty());



  @override
  Stream<StudentListState> mapEventToState(
      StudentListEvent event
      ) async*{
    if(event is FetchStudentList){
      yield StudentListLoading();
      try{
        StudentList aList = await studentRepository.getStudentList(event.class_id,event.section_id,event.search);
        yield StudentListLoaded(aList: aList);
      }
      catch (e){
        yield StudentListError(errorMessage: e.toString());
      }
    }

    else if(event is FetchStudentListForAllClass){
      yield StudentListForAllClassLoading();
      try{
        StudentListForAllClassModel studentListForAllClass = await studentRepository.getStudentListForAllClass(
                                        event.search);
        yield StudentListForAllClassLoaded(studentListForAllClass: studentListForAllClass);
      }
      catch (e){
        yield StudentListForAllClassError(errorMessage: e.toString());
      }
    }
  }
}