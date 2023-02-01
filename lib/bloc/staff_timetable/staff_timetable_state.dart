import 'package:equatable/equatable.dart';
import 'package:smk/models/staff_timetable/staff_timetable_model.dart';

import '../../models/announcements/announcement_model.dart';

abstract class StaffTimetableState extends Equatable{
  @override
  List<Object> get props => [];
}

class StaffTimetableEmpty extends StaffTimetableState{}

class StaffTimetableLoading extends StaffTimetableState{}

class StaffTimetableLoaded extends StaffTimetableState{
  final StaffTimetableList staffTimetableList;
  StaffTimetableLoaded({required this.staffTimetableList});
}

class StaffTimetableError extends StaffTimetableState{
  final String errorMessage;
  StaffTimetableError({required this.errorMessage});
}