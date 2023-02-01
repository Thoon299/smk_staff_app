import 'package:bloc/bloc.dart';
import 'package:smk/bloc/staff_permission/stf_per_event.dart';
import 'package:smk/bloc/staff_permission/stf_per_state.dart';

import '../../data/repository/stf_per_repository.dart';
import '../../models/staff_permission/stf_per_model.dart';

class StfPerBloc extends Bloc<StfPerEvent,StfPerState>{
  final StfPerRepository stfPerRepository;
  StfPerBloc(this.stfPerRepository) : super(StfPerEmpty());

  @override
  Stream<StfPerState> mapEventToState(
      StfPerEvent event
      ) async*{
    if(event is FetchStfPer){
      yield StfPerLoading();
      try{
        StfPerModel stfPerModel = await stfPerRepository.getStfPer();
        yield StfPerLoaded(stfPerModel: stfPerModel);
      }
      on Exception{
        yield StfPerError(errorMessage: 'Fail to get permission information.');
      }
      catch(e){
        yield StfPerError(errorMessage: e.toString());
      }
    }
    // else if (event is ProfileStart){
    //   yield ProfileEmpty();
    // }
  }
}