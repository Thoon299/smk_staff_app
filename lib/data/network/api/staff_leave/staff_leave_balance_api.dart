import 'dart:async';
import '../../../../models/staff_leave/staff_leave_balance_list_model.dart';
import '../../../../models/staff_leave/staff_leave_balance_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StaffLeaveBalanceApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StaffLeaveBalanceApi(this._dioClient);


  Future<StaffLeaveBalanceModel> getStaffLeaveBalance() async {
    final res = await _dioClient.get(Endpoints.staffLeaveBalance);
    return StaffLeaveBalanceModel.fromJson(res);
  }



}
