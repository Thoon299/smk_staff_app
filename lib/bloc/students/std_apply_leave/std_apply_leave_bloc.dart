import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/students/std_apply_leave/std_apply_leave_event.dart';
import 'package:smk/bloc/students/std_apply_leave/std_apply_leave_state.dart';
import 'package:smk/models/student_attendence_marking/post_response.dart';

import '../../../data/repository/std_apply_leave_repository.dart';
import '../../../models/std_apply_leave/std_apply_leave_model.dart';
import '../../../models/std_apply_leave/std_apply_leave_status_model.dart';


class StdApplyLeaveBloc extends Bloc<StdApplyLeaveEvent,StdApplyLeaveState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StdApplyLeaveRepository stdApplyLeaveRepository;
  StdApplyLeaveBloc(this.stdApplyLeaveRepository) : super(StdApplyLeaveEmpty());
  List<PostData> StudentListDataList=[];


  @override
  Stream<StdApplyLeaveState> mapEventToState(
      StdApplyLeaveEvent event
      ) async*{
    if(event is FetchStdApplyLeave){
      yield StdApplyLeaveLoading();
      try{
        StdApplyLeaveModel stdApplyLeaveModel =
        await stdApplyLeaveRepository.getStdApplyLeave(
            event.date, event.id);
        yield StdApplyLeaveLoaded(stdApplyLeaveModel: stdApplyLeaveModel);
      }
      catch (e){
        yield StdApplyLeaveError(errorMessage: e.toString());
      }
    }

    else if(event is UpdateStdApplyLeaveStatus){
      yield StdApplyLeaveStatusLoading();
      try{
        StdApplyLeaveStatusModel stdApplyLeaveStatusModel =
        (await stdApplyLeaveRepository.updateStdApplyLeaveStatus(
            event.student_applyleave_id, event.status)) as StdApplyLeaveStatusModel;

      }
      catch (e){
        yield StdApplyLeaveStatusError(errorMessage: e.toString());
      }
    }
  }
}