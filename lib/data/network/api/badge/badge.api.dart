import 'dart:async';
import 'package:smk/models/announcements/noti_update.dart';
import 'package:smk/models/badge_model.dart';

import '../../dio_client.dart';
import '../constants/endpoints.dart';

class BadgeApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  BadgeApi(this._dioClient);


  Future<BadgeModel> getBadge(type) async {
    final res = await _dioClient.get(Endpoints.badge+"/$type");
    return BadgeModel.fromJson(res);
  }

  //update badge
  Future<BadgeUpdate> getUpdateBadge(type) async {
    final res = await _dioClient.get(Endpoints.updateBadge+"/$type");
    return BadgeUpdate.fromJson(res);
  }

}
