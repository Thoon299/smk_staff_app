import 'dart:async';
import '../../../../models/std_apply_leave/std_apply_leave_edit_response.dart';
import '../../../../models/std_apply_leave/std_apply_leave_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StdApplyLeaveApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StdApplyLeaveApi(this._dioClient);


  Future<StdApplyLeaveModel> getStdApplyLeave(date, id) async {
    final res = await _dioClient.get(Endpoints.std_apply_leave+"/$date"+"/$id");
    return StdApplyLeaveModel.fromJson(res);
  }

  Future<StdApplyLeaveModel> updateStdApplyLeaveStatus(student_applyleave_id,status) async {
    final res = await _dioClient.get(Endpoints.std_apply_leave_status+"/$student_applyleave_id"+"/$status");
    return StdApplyLeaveModel.fromJson(res);
  }
  Future<StdApplyLeaveEditResponse> stdApplyLeaveEdit({required formData,required student_applyleave_id}) async {
    final res=await _dioClient.post(Endpoints.stdApplyLeaveEdit+"/$student_applyleave_id",data: formData);
    return StdApplyLeaveEditResponse.fromJson(res);
  }


}
