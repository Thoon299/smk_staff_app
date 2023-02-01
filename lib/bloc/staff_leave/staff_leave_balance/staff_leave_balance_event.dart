import 'package:equatable/equatable.dart';

abstract class StaffLeaveBalanceEvent extends Equatable{
  const StaffLeaveBalanceEvent();

  @override
  List<Object> get props => [];
}

class FetchStaffLeaveBalance extends StaffLeaveBalanceEvent{

  FetchStaffLeaveBalance();
}
