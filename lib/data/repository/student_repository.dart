

import 'package:smk/models/announcements/announcement_list_model.dart';
import 'package:smk/models/students/students_list_forallclass_model.dart';

import '../../models/announcements/announcement_model.dart';
import '../../models/students/student_detail_forallclass_model.dart';
import '../../models/students/student_detail_model.dart';
import '../../models/students/student_home_model.dart';
import '../../models/students/student_list_model.dart';
import '../../ui/students/student_detail.dart';
import '../network/api/announcement/announcement_api.dart';
import '../network/api/students/student_api.dart';
import '../sharedpreference/shared_preference_helper.dart';

class StudentRepository {
  //api object
  final StudentApi studentApi;

  //shared pref object


  //constructor
  StudentRepository(
      this.studentApi,

      );

  Future<StudentHome> getStudentHome(search) async {
    return studentApi.getStudentHome(search);
  }

  Future<StudentList> getStudentList(class_id,section_id,search) async {
    return studentApi.getStudentList(class_id,section_id,search);
  }

  Future<StudentListForAllClassModel> getStudentListForAllClass(search) async {
    return studentApi.getStudentListForAllClass(search);
  }

  Future<StudentDetailModel> getStudentDetail(student_id) async {
    return studentApi.getStudentDetail(student_id);
  }

  Future<StudentDetailForAllClassModel> getStudentDetailForAllClass(student_id) async {
    return studentApi.getStudentDetailForAllClass(student_id);
  }



}
