
import 'package:smk/models/std_apply_leave/std_apply_leave_model.dart';

import '../../models/std_apply_leave/std_apply_leave_edit_response.dart';
import '../network/api/std_apply_leave/std_apply_leave_api.dart';

class StdApplyLeaveRepository {
  //api object
  final StdApplyLeaveApi _stdApplyLeaveApi;

  //shared pref object
  // final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  StdApplyLeaveRepository(this._stdApplyLeaveApi);


  //post
  Future<StdApplyLeaveModel> getStdApplyLeave(date, id) async {
    return _stdApplyLeaveApi.getStdApplyLeave(date, id);
  }
  Future<StdApplyLeaveModel> updateStdApplyLeaveStatus(student_applyleave_id,status) async {
    return _stdApplyLeaveApi.updateStdApplyLeaveStatus(student_applyleave_id,status);
  }
  Future<StdApplyLeaveEditResponse> stdApplyLeaveEdit({required formData,required student_applyleave_id}) async {
    return  _stdApplyLeaveApi.stdApplyLeaveEdit(formData: formData,student_applyleave_id: student_applyleave_id);
  }


}
