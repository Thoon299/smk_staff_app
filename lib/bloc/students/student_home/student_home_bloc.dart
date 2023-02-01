import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/announcements/announcement_state.dart';
import 'package:smk/bloc/students/student_home/student_home_event.dart';
import 'package:smk/bloc/students/student_home/student_home_state.dart';
import 'package:smk/data/repository/student_repository.dart';

import '../../../models/students/student_home_model.dart';



class StudentHomeBloc extends Bloc<StudentHomeEvent,StudentHomeState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StudentRepository studentRepository;
  StudentHomeBloc(this.studentRepository) : super(StudentHomeEmpty());
  List<PostData> StudentHomeDataList=[];


  @override
  Stream<StudentHomeState> mapEventToState(
      StudentHomeEvent event
      ) async*{
    if(event is FetchStudentHome){
      yield StudentHomeLoading();
      try{
        StudentHome aList = await studentRepository.getStudentHome(event.search);
        yield StudentHomeLoaded(aList: aList);
      }
      catch (e){
        yield StudentHomeError(errorMessage: e.toString());
      }
    }
  }
}