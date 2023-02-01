import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class NewEvent extends Equatable{
  const NewEvent();

  @override
  List<Object> get props => [];
}

class NewStart extends NewEvent{}

class New extends NewEvent{
  String student_session_id;
  String student_attendence_id;
  String date;
  String type;

  New({required this.student_session_id, required this.student_attendence_id, required this.date, required this.type});
}

