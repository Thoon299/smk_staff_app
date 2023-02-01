import 'package:equatable/equatable.dart';

import '../../models/staff/staff_model.dart';

abstract class StaffState extends Equatable{
  @override
  List<Object> get props => [];
}

class StaffEmpty extends StaffState{}

class StaffLoading extends StaffState{}

class StaffLoaded extends StaffState{
  final StaffModel staffModel;
  StaffLoaded({required this.staffModel});
}

class StaffError extends StaffState{
  final String errorMessage;
  StaffError({required this.errorMessage});
}