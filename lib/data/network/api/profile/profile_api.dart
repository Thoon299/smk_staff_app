import 'package:dio/dio.dart';
import '../../../../models/profile_model.dart';
import '../../dio_client.dart';
import 'dart:io';

import '../constants/endpoints.dart';

class ProfileApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  ProfileApi(this._dioClient);

  Future<ProfileModel> getProfile() async {
    final res = await _dioClient.get(Endpoints.profile);
    return ProfileModel.fromJson(res);
  }

}
// dio.options.headers={
// 'Content-Type':"multipart/form-data",
// 'Accept':'application/json'
// };

