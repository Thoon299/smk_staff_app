
import 'package:smk/models/staff/staff_model.dart';

import '../network/api/staff/staff_api.dart';

class StaffRepository {
  //api object
  final StaffApi staffApi;

  //shared pref object


  //constructor
  StaffRepository(
      this.staffApi,

      );

  Future<StaffModel> getStaff(search) async {
    return staffApi.getStaff(search);
  }

}
