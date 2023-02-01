import '../../../../models/staff_leave/stfLevApply_post_response.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StfLevApplyApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StfLevApplyApi(this._dioClient);

  //post
  Future<StfLevApplyPostResponse> postStdAttMaringNew({required formData}) async {
    final res=await _dioClient.post(Endpoints.staff_lev_apply,data: formData);
    return StfLevApplyPostResponse.fromJson(res);
  }

}
