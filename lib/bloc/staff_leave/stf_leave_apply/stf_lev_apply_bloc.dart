import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:smk/bloc/staff_leave/stf_leave_apply/stf_lev_apply_event.dart';
import 'package:smk/bloc/staff_leave/stf_leave_apply/stf_lev_apply_state.dart';

import '../../../data/repository/staff_leave_apply_repository.dart';
import '../../../models/staff_leave/stfLevApply_post_response.dart';


class StfLevApplyBloc extends Bloc<StfLevApplyEvent,StfLevApplyState>{
  StfLevApplyRepository stfLevApplyRepository;
  StfLevApplyBloc(this.stfLevApplyRepository) : super(StfLevApplyInitialize());

  @override
  Stream<StfLevApplyState> mapEventToState(StfLevApplyEvent event) async* {
    if (event is StfLevApplyStart) {
      yield StfLevApplyInitialize();
    }

    else if (event is StfLevApply) {
      yield StfLevApplyLoading();
      String? fileString;
      try {

        var formData = FormData.fromMap({
          'applied_date': event.applied_date,
          'leave_type' : event.leave_type,
          'reason' : event.reason,
          'from_date': event.from_date,
          'to_date': event.to_date,
          'leavedate' : event.leavedate,
          'half_leave' : event.half_leave,


         // 'file': await MultipartFile.fromFile(
         //   event.file.path, filename: fileString,),
        });
        StfLevApplyPostResponse stfLevApplyPostResponse =
                          await stfLevApplyRepository.postStfLevApply(
            formData: formData);
        yield StfLevApplyLoaded(success: stfLevApplyPostResponse.success.toString());
      }
      catch (e) {
        yield StfLevApplyError(errorMessage: e.toString());
      }
    }
    else if (event is StfLevApplyWithFile) {
      yield StfLevApplyLoading();
      String? fileString;
      try {
        fileString = event.userfile
            .path
            .split('/')
            .last;
        var formData = FormData.fromMap({
          'applied_date': event.applied_date,
          'leave_type' : event.leave_type,
          'reason' : event.reason,
          'from_date': event.from_date,
          'to_date': event.to_date,
          'leavedate' : event.leavedate,
          'half_leave' : event.half_leave,
          'userfile': await MultipartFile.fromFile(
            event.userfile.path, filename: fileString,),

          // 'file': await MultipartFile.fromFile(
          //   event.file.path, filename: fileString,),
        });
        StfLevApplyPostResponse stfLevApplyPostResponse =
        await stfLevApplyRepository.postStfLevApply(
            formData: formData);
        yield StfLevApplyLoaded(success: stfLevApplyPostResponse.success.toString());
      }
      catch (e) {
        yield StfLevApplyError(errorMessage: e.toString());
      }
    }
  }


}