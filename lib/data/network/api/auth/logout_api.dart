import 'dart:async';
import 'package:smk/models/logoutReplyModel.dart';

import '../../dio_client.dart';
import '../constants/endpoints.dart';

class LogoutApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  LogoutApi(this._dioClient);

  Future<LogoutReplyModel> logoutStaff(fcm_token) async {
    final res = await _dioClient.get(Endpoints.logoutStaff+"/$fcm_token");
    return LogoutReplyModel.fromJson(res);
  }

}
