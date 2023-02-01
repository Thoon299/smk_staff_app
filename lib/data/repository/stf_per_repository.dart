
import 'dart:io';

import 'package:smk/models/staff_permission/stf_per_model.dart';

import '../network/api/staff_permission/stf_per_api.dart';

class StfPerRepository {
  //api object
  final StfPerApi stfPerApi;

  StfPerRepository(this.stfPerApi);

  Future<StfPerModel> getStfPer() async {
    return stfPerApi.getStfPer();
  }


}
