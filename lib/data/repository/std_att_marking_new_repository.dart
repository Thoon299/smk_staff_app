import '../../models/student_attendence_marking/post_response.dart';
import '../network/api/student_attendence_marking/std_att_marking_new_api.dart';

class StdAttMaringNewRepository {
  //api object
  final StdAttMaringNewApi _stdAttMaringNewApi;

  //shared pref object
  // final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  StdAttMaringNewRepository(this._stdAttMaringNewApi);


  //post
  Future<StdAttPostResponse> postStdAttMaringNew({required formData})async{
    return _stdAttMaringNewApi.postStdAttMaringNew(formData: formData);
  }




}
