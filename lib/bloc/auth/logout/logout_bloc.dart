import 'package:bloc/bloc.dart';
import 'package:smk/models/logoutReplyModel.dart';

import '../../../data/repository/logout_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent,LogoutState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  LogoutRepository logoutRepository;
  LogoutBloc(this.logoutRepository) : super(LogoutEmpty());


  @override
  Stream<LogoutState> mapEventToState(
      LogoutEvent event
      ) async*{

     if(event is FetchLogout){
      yield LogoutLoading();
      try{
        LogoutReplyModel logoutReplyModel =
        await logoutRepository.logoutStaff(
            event.fcm_token);

      }
      catch (e){
        yield LogoutError(errorMessage: e.toString());
      }
    }
  }
}