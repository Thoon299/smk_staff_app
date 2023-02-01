

import 'package:smk/data/network/api/staff_timetable/staff_timetable_api.dart';
import 'package:smk/models/staff_timetable/staff_timetable_model.dart';

import '../../models/announcements/announcement_model.dart';
import '../network/api/announcement/announcement_api.dart';
import '../sharedpreference/shared_preference_helper.dart';

class StaffTimetableRepository {
  //api object
  final StaffTimetableApi _staffTimetableApi;

  //shared pref object


  //constructor
  StaffTimetableRepository(
      this._staffTimetableApi,

      );

  Future<StaffTimetableList> getStaffTimetalbeList(day) async {
    return _staffTimetableApi.getStaffTimetableList(day);
  }


}
