import 'package:equatable/equatable.dart';

abstract class StfLevBalListEvent extends Equatable{
  const StfLevBalListEvent();

  @override
  List<Object> get props => [];
}

class FetchStfLevBalList extends StfLevBalListEvent{

  FetchStfLevBalList();
}
