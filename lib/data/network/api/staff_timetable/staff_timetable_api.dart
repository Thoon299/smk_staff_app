import 'dart:async';
import 'package:dio/dio.dart';
import 'package:smk/models/staff_timetable/staff_timetable_model.dart';

import '../../../../models/announcements/announcement_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StaffTimetableApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StaffTimetableApi(this._dioClient);


  Future<StaffTimetableList> getStaffTimetableList(day) async {
    final res = await _dioClient.get(Endpoints.staffTimetableList+"/$day");
    return StaffTimetableList.fromJson(res);
  }

}
