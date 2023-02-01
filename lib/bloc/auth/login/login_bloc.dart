import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(LoginInitialized());

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if(event is LoginPressedButton){
      yield LoginLoading();
      try{
        final dio = Dio();
        var formData = FormData.fromMap({
          'email':event.email,
          'password':event.password,
          'deviceToken' : event.deviceToken,
          'oldFcmToken' : event.oldFcmToken,
        });

        dio
          ..options.baseUrl = "https://uat.smkedugroup.com/api"
          ..options.responseType = ResponseType.json
          ..options.followRedirects = false
          ..options.headers = {'Content-Type': 'application/json'}
          ..options.headers = {'Client-Service': 'smartschool'}

          ..options.headers['Accept'] = 'application/json';
        dio.interceptors.add(PrettyDioLogger());
        final LoginResponse = await dio.post('/auth/loginStaff',data: formData);

        if(LoginResponse.statusCode!=200){
          yield LoginError(errorMessage: 'User is not Staff.PLease Login In again.');
        }
        else{
          try{
            yield LoginSuccess(verify_token: LoginResponse.data['verify_token']);
          }
          catch(e){
            // print(memberLoginResponse.data['message']);
            yield LoginError(errorMessage: 'User is not Staff.PLease Login In again.');
          }
        }
      }
      catch(e){
        print("ERRORR is ${e.toString()}");
        yield LoginError(errorMessage: e.toString());
      }
    }
  }
}