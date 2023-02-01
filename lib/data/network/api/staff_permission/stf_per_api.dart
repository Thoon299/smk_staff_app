import 'package:dio/dio.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/staff_permission/stf_per_model.dart';
import '../../dio_client.dart';
import 'dart:io';

import '../constants/endpoints.dart';

class StfPerApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StfPerApi(this._dioClient);

  Future<StfPerModel> getStfPer() async {
    final res = await _dioClient.get(Endpoints.stfPer);
    return StfPerModel.fromJson(res);
  }

}
// dio.options.headers={
// 'Content-Type':"multipart/form-data",
// 'Accept':'application/json'
// };

