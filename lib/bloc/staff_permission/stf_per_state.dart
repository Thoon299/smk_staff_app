import 'package:equatable/equatable.dart';

import '../../models/staff_permission/stf_per_model.dart';


abstract class StfPerState extends Equatable{
  @override
  List<Object> get props => [];
}

class StfPerEmpty extends StfPerState {}
class StfPerLoading extends StfPerState{}

class StfPerLoaded extends StfPerState{
  final StfPerModel stfPerModel;
  StfPerLoaded({required this.stfPerModel});
}

class StfPerError extends StfPerState{
  final String errorMessage;
  StfPerError({required this.errorMessage});
}