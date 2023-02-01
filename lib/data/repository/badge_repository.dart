
import 'package:smk/models/announcements/noti_update.dart';
import 'package:smk/models/badge_model.dart';

import '../network/api/badge/badge.api.dart';

class BadgeRepository {
  //api object
  final BadgeApi _badgeApi;

  //shared pref object


  //constructor
  BadgeRepository(
      this._badgeApi,

      );

  Future<BadgeModel> getBadge(type) async {
    return _badgeApi.getBadge(type);
  }


  //badge update
  Future<BadgeUpdate> updateBadge(type) async {
    return _badgeApi.getUpdateBadge(type);
  }


}
