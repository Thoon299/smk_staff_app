import 'package:equatable/equatable.dart';

import '../../../models/staff_leave/staff_leave_balance_list_model.dart';

abstract class StfLevBalListState extends Equatable{
  @override
  List<Object> get props => [];
}

class StfLevBalListEmpty extends StfLevBalListState{}

class StfLevBalListLoading extends StfLevBalListState{}

class StfLevBalListLoaded extends StfLevBalListState{
  final StfLevBalListModel stfLevBalListModel;
  StfLevBalListLoaded({required this.stfLevBalListModel});
}

class StfLevBalListError extends StfLevBalListState{
  final String errorMessage;
  StfLevBalListError({required this.errorMessage});
}
