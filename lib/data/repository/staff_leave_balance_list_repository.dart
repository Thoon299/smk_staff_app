
import '../../models/staff_leave/staff_leave_balance_list_model.dart';
import '../network/api/staff_leave/staff_leave_balance_list_api.dart';

class StfLevBalListRepository {
  //api object
  final StfLevBalListApi stfLevBalListApi;

  //shared pref object


  //constructor
  StfLevBalListRepository(
      this.stfLevBalListApi,

      );

  Future<StfLevBalListModel> getStfLevBalList() async {
    return stfLevBalListApi.getStfLevBalList();
  }


}
