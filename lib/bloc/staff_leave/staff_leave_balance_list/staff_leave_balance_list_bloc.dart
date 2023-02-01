import 'package:bloc/bloc.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance_list/staff_leave_balance_list_event.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance_list/staff_leave_balance_list_state.dart';

import '../../../data/repository/staff_leave_balance_list_repository.dart';
import '../../../models/staff_leave/staff_leave_balance_list_model.dart';


class StfLevBalListBloc extends Bloc<StfLevBalListEvent,StfLevBalListState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StfLevBalListRepository stfLevBalListRepository;
  StfLevBalListBloc(this.stfLevBalListRepository) : super(StfLevBalListEmpty());



  @override
  Stream<StfLevBalListState> mapEventToState(
      StfLevBalListEvent event
      ) async* {
    if (event is FetchStfLevBalList) {
      yield StfLevBalListLoading();
      try {
        StfLevBalListModel stfLevBalListModel = await stfLevBalListRepository.getStfLevBalList();
        yield StfLevBalListLoaded(stfLevBalListModel: stfLevBalListModel);
      }
      catch (e) {
        yield StfLevBalListError(errorMessage: e.toString());
      }
    }
  }
}