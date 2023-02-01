import 'package:equatable/equatable.dart';

import '../../../models/staff_leave/staff_leave_balance_list_model.dart';
import '../../../models/staff_leave/staff_leave_balance_model.dart';

abstract class StaffLeaveBalanceState extends Equatable{
  @override
  List<Object> get props => [];
}

class StaffLeaveBalanceEmpty extends StaffLeaveBalanceState{}

class StaffLeaveBalanceLoading extends StaffLeaveBalanceState{}

class StaffLeaveBalanceLoaded extends StaffLeaveBalanceState{
  final StaffLeaveBalanceModel staffLeaveBalanceModel;
  StaffLeaveBalanceLoaded({required this.staffLeaveBalanceModel});
}

class StaffLeaveBalanceError extends StaffLeaveBalanceState{
  final String errorMessage;
  StaffLeaveBalanceError({required this.errorMessage});
}
