import 'package:dio/dio.dart';

import '../../../../models/student_attendence_marking/post_response.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StdAttMaringNewApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StdAttMaringNewApi(this._dioClient);

  //post
  Future<StdAttPostResponse> postStdAttMaringNew({required formData}) async {
    final res=await _dioClient.post(Endpoints.std_att_marking_new,data: formData);
    return StdAttPostResponse.fromJson(res);
  }

}
