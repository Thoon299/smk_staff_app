import 'dart:async';

import 'package:smk/models/student_attendence_marking/student_attendence_marking_model.dart';
import 'package:smk/ui/students/student_attendence/student_attendence_marking_new.dart';

import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StudentAttendenceMarkingApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StudentAttendenceMarkingApi(this._dioClient);


  Future<StudentAttendenceMarkingModel> getStudentAttendenceMarking(class_id,session_id,date) async {
    final res = await _dioClient.get(Endpoints.student_attendence_marking+"/$class_id"+"/$session_id"+"/$date");
    return StudentAttendenceMarkingModel.fromJson(res);
  }



}
