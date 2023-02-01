

import 'package:smk/models/announcements/AnnDetailModel.dart';
import 'package:smk/models/announcements/announcement_list_model.dart';

import '../../models/announcements/announcement_model.dart';
import '../../models/announcements/noti_model.dart';
import '../network/api/announcement/announcement_api.dart';
import '../sharedpreference/shared_preference_helper.dart';

class AnnouncementRepository {
  //api object
  final AnnouncementApi _announcementApi;

  //shared pref object


  //constructor
  AnnouncementRepository(
      this._announcementApi,

      );

  Future<Announcement> getAnnouncement() async {
    return _announcementApi.getAnnouncement();
  }

  Future<AnnouncementList> getAnnouncementList() async {
    return _announcementApi.getAnnouncementList();
  }

  //noti's------------------------------------
  Future<NotiModel> getNoti() async {
    return _announcementApi.getNoti();
  }

//ann detail's====================================
  Future<AnnDetailModel> getAnnDetail(id) async {
    return _announcementApi.getAnnDetail(id);
  }



}
