import 'package:equatable/equatable.dart';

abstract class StaffEvent extends Equatable{
  const StaffEvent();

  @override
  List<Object> get props => [];
}

class FetchStaff extends StaffEvent{
  String search;
  FetchStaff({required this.search});
}