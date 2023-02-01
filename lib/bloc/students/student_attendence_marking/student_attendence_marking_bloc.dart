import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/students/student_attendence_marking/student_attendence_marking_event.dart';
import 'package:smk/bloc/students/student_attendence_marking/student_attendence_marking_state.dart';
import 'package:smk/bloc/students/student_list/student_list_event.dart';
import 'package:smk/bloc/students/student_list/student_list_state.dart';

import '../../../data/repository/student_attendence_marking_repository.dart';
import '../../../models/student_attendence_marking/student_attendence_marking_model.dart';




class StudentAttendenceMarkingBloc extends Bloc<StudentAttendenceMarkingEvent,StudentAttendenceMarkingState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StudentAttendenceMarkingRepository studentAttendenceMarkingRepository;
  StudentAttendenceMarkingBloc(this.studentAttendenceMarkingRepository) : super(StudentAttendenceMarkingEmpty());
  List<PostData> StudentListDataList=[];


  @override
  Stream<StudentAttendenceMarkingState> mapEventToState(
      StudentAttendenceMarkingEvent event
      ) async*{
    if(event is FetchStudentAttendenceMarking){
      yield StudentAttendenceMarkingLoading();
      try{
        StudentAttendenceMarkingModel studentAttendenceMarkingModel =
              await studentAttendenceMarkingRepository.getStudentAttendenceMarking(
                  event.class_id, event.session_id, event.date);
        yield StudentAttendenceMarkingLoaded(studentAttendenceMarkingModel: studentAttendenceMarkingModel);
      }
      catch (e){
        yield StudentAttendenceMarkingError(errorMessage: e.toString());
      }
    }
  }
}