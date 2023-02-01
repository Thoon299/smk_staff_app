import 'package:equatable/equatable.dart';

abstract class StaffTimetableEvent extends Equatable{
  const StaffTimetableEvent();

  @override
  List<Object> get props => [];
}

class FetchStaffTimetable extends StaffTimetableEvent{
  String day;
  FetchStaffTimetable({ required this.day});


}