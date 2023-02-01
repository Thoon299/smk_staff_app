
import '../../models/staff_leave/staff_leave_balance_list_model.dart';
import '../../models/staff_leave/staff_leave_balance_model.dart';
import '../network/api/staff_leave/staff_leave_balance_api.dart';

class StaffLeaveBalanceRepository {
  //api object
  final StaffLeaveBalanceApi staffLeaveBalanceApi;

  //shared pref object


  //constructor
  StaffLeaveBalanceRepository(
      this.staffLeaveBalanceApi,

      );

  Future<StaffLeaveBalanceModel> getStaffLeaveBalance() async {
    return staffLeaveBalanceApi.getStaffLeaveBalance();
  }


}
