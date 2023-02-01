import 'dart:async';
import '../../../../models/staff_leave/staff_leave_balance_list_model.dart';
import '../../../../models/staff_leave/staff_leave_balance_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class StfLevBalListApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  StfLevBalListApi(this._dioClient);


  Future<StfLevBalListModel> getStfLevBalList() async {
    final res = await _dioClient.get(Endpoints.StfLevBalList);
    return StfLevBalListModel.fromJson(res);
  }



}
