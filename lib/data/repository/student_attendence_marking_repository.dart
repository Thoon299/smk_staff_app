
import 'package:smk/data/network/api/student_attendence_marking/student_attendence_marking_api.dart';
import 'package:smk/models/student_attendence_marking/student_attendence_marking_model.dart';

class StudentAttendenceMarkingRepository {
  //api object
  final StudentAttendenceMarkingApi studentAttendenceMarkingApi;

  //shared pref object


  //constructor
  StudentAttendenceMarkingRepository(
      this.studentAttendenceMarkingApi,

      );

  Future<StudentAttendenceMarkingModel> getStudentAttendenceMarking(class_id, session_id, date) async {
    return studentAttendenceMarkingApi.getStudentAttendenceMarking(class_id, session_id, date);
  }





}
