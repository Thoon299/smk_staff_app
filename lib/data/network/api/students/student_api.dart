import 'dart:async';
import 'package:dio/dio.dart';
import 'package:smk/models/announcements/announcement_list_model.dart';

import '../../../../models/announcements/announcement_model.dart';
import '../../../../models/students/student_detail_forallclass_model.dart';
import '../../../../models/students/student_detail_model.dart';
import '../../../../models/students/student_home_model.dart';
import '../../../../models/students/student_list_model.dart';
import '../../../../models/students/students_list_forallclass_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StudentApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StudentApi(this._dioClient);


  Future<StudentHome> getStudentHome(search) async {
    final res = await _dioClient.get(Endpoints.studentHome+"/$search");
    return StudentHome.fromJson(res);
  }

  Future<StudentList> getStudentList(class_id,section_id,search) async {
    final res = await _dioClient.get(Endpoints.studentList+"/$class_id"+"/$section_id"+"/$search");
    return StudentList.fromJson(res);
  }
  Future<StudentListForAllClassModel> getStudentListForAllClass(search) async {
    final res = await _dioClient.get(Endpoints.studentListForAllClass+"/$search");
    return StudentListForAllClassModel.fromJson(res);
  }


  Future<StudentDetailModel> getStudentDetail(student_id) async {
    final res = await _dioClient.get(Endpoints.studentDetail+"/$student_id");
    return StudentDetailModel.fromJson(res);
  }

  Future<StudentDetailForAllClassModel> getStudentDetailForAllClass(student_id) async {
    final res = await _dioClient.get(Endpoints.studentDetailForAllClass+"/$student_id");
    return StudentDetailForAllClassModel.fromJson(res);
  }


}
