import 'package:bloc/bloc.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance/staff_leave_balance_event.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance/staff_leave_balance_state.dart';

import '../../../data/repository/staff_leave_balance_repository.dart';
import '../../../models/staff_leave/staff_leave_balance_model.dart';


class StaffLeaveBalanceBloc extends Bloc<StaffLeaveBalanceEvent,StaffLeaveBalanceState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StaffLeaveBalanceRepository staffLeaveBalanceRepository;
  StaffLeaveBalanceBloc(this.staffLeaveBalanceRepository) : super(StaffLeaveBalanceEmpty());



  @override
  Stream<StaffLeaveBalanceState> mapEventToState(
      StaffLeaveBalanceEvent event
      ) async* {
    if (event is FetchStaffLeaveBalance) {
      yield StaffLeaveBalanceLoading();
      try {
        StaffLeaveBalanceModel staffLeaveBalanceModel = await staffLeaveBalanceRepository
            .getStaffLeaveBalance();
        yield StaffLeaveBalanceLoaded(
            staffLeaveBalanceModel: staffLeaveBalanceModel);
      }
      catch (e) {
        yield StaffLeaveBalanceError(errorMessage: e.toString());
      }
    }
  }
}