import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:smk/bloc/students/std_apply_leave/std_apply_leave_edit/stdApplyLeave_edit_event.dart';
import 'package:smk/bloc/students/std_apply_leave/std_apply_leave_edit/stdApplyLeave_edit_state.dart';

import '../../../../data/repository/std_apply_leave_repository.dart';
import '../../../../models/std_apply_leave/std_apply_leave_edit_response.dart';


class StdApplyLeaveEditBloc extends Bloc<StdApplyLeaveEditEvent,StdApplyLeaveEditState>{
  StdApplyLeaveRepository stdApplyLeaveRepository;
  StdApplyLeaveEditBloc(this.stdApplyLeaveRepository) : super(StdApplyLeaveEditInitialize());

  @override
  Stream<StdApplyLeaveEditState> mapEventToState(StdApplyLeaveEditEvent event) async*{
    if (event is StdApplyLeaveEditStart){
      yield StdApplyLeaveEditInitialize();
    }
    else if(event is FormStdApplyLeaveEdit){
      yield StdApplyLeaveEditLoading();
      try{
        var formData = FormData.fromMap({
          'student_applyleave_id':event.student_applyleave_id,
          'from_date':event.from_date,
          'to_date':event.to_date,
          'apply_date':event.apply_date,
          'reason':event.reason,
        });
        StdApplyLeaveEditResponse gapPostResponse = await stdApplyLeaveRepository.stdApplyLeaveEdit
          (formData: formData,student_applyleave_id: event.student_applyleave_id);
        yield StdApplyLeaveEditLoaded(success: gapPostResponse.success.toString());
      }
      catch(e){
        yield StdApplyLeaveEditError(errorMessage: e.toString());
      }
    }



  }
}
