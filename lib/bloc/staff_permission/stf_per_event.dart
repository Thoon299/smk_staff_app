import 'package:equatable/equatable.dart';

abstract class StfPerEvent extends Equatable{
  const StfPerEvent();
  @override
  List<Object> get props=>[];
}

// class ProfileStart extends ProfileEvent{}

class FetchStfPer extends StfPerEvent{

  FetchStfPer();
}