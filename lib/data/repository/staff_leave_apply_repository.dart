
import '../../models/staff_leave/stfLevApply_post_response.dart';
import '../network/api/staff_leave/staff_leave_apply_api.dart';

class StfLevApplyRepository {
  //api object
  final StfLevApplyApi _stfLevApplyApi;

  //shared pref object
  // final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  StfLevApplyRepository(this._stfLevApplyApi);


  //post
  Future<StfLevApplyPostResponse> postStfLevApply({required formData})async{
    return _stfLevApplyApi.postStdAttMaringNew(formData: formData);
  }




}
