import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class StfLevApplyEvent extends Equatable{
  const StfLevApplyEvent();

  @override
  List<Object> get props => [];
}

class StfLevApplyStart extends StfLevApplyEvent{}

class StfLevApply extends StfLevApplyEvent{
  String applied_date;
  String leave_type;
  String reason;
  String from_date;
  String to_date;
  String leavedate;
  int half_leave;


  StfLevApply({required this.applied_date, required this.leave_type, required this.from_date,
    required this.to_date, required this.reason, required this.leavedate, required this.half_leave,
  });
}

class StfLevApplyWithFile extends StfLevApplyEvent{
  String applied_date;
  String leave_type;
  String reason;
  String from_date;
  String to_date;
  String leavedate;
  int half_leave;
  File userfile;

  StfLevApplyWithFile({required this.applied_date, required this.leave_type, required this.from_date,
    required this.to_date, required this.reason, required this.leavedate, required this.half_leave,
    required this.userfile});
}

