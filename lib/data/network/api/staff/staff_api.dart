import 'dart:async';
import '../../../../models/staff/staff_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StaffApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StaffApi(this._dioClient);


  Future<StaffModel> getStaff(search) async {
    final res = await _dioClient.get(Endpoints.staff+"/$search");
    return StaffModel.fromJson(res);
  }


}
