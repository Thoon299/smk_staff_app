

import 'package:smk/models/logoutReplyModel.dart';

import '../network/api/auth/logout_api.dart';

class LogoutRepository {
  //api object
  final LogoutApi logoutApi;

  //shared pref object
  // final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  LogoutRepository(this.logoutApi);


  //post

  Future<LogoutReplyModel> logoutStaff(fcm_token) async {
    return logoutApi.logoutStaff(fcm_token);
  }



}
