import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:smk/models/student_attendence_marking/post_response.dart';
import '../../../../data/repository/std_att_marking_new_repository.dart';
import 'new_event.dart';
import 'new_state.dart';

class NewBloc extends Bloc<NewEvent,NewState>{
  StdAttMaringNewRepository stdAttMaringNewRepository;
  NewBloc(this.stdAttMaringNewRepository) : super(NewInitialize());

  @override
  Stream<NewState> mapEventToState(NewEvent event) async* {
    if (event is NewStart) {
      yield NewInitialize();
    }

    else if (event is New) {
      yield NewLoading();
      try {
        var formData = FormData.fromMap({
          'student_session_id': event.student_session_id,
          'student_attendence_id' : event.student_attendence_id,
          'date': event.date,
          'type': event.type,
        });
        StdAttPostResponse PostResponse = await stdAttMaringNewRepository.postStdAttMaringNew(
            formData: formData);
        yield NewLoaded(success: PostResponse.success.toString());
      }
      catch (e) {
        yield NewError(errorMessage: e.toString());
      }
    }
  }


}