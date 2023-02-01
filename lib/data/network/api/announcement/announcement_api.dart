import 'dart:async';
import 'package:dio/dio.dart';
import 'package:smk/models/announcements/AnnDetailModel.dart';
import 'package:smk/models/announcements/announcement_list_model.dart';

import '../../../../models/announcements/announcement_model.dart';
import '../../../../models/announcements/noti_model.dart';
import '../../dio_client.dart';
import '../constants/endpoints.dart';

class AnnouncementApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  AnnouncementApi(this._dioClient);


  Future<Announcement> getAnnouncement() async {
    final res = await _dioClient.get(Endpoints.announcement);
    return Announcement.fromJson(res);
  }
  Future<AnnouncementList> getAnnouncementList() async {
    final res = await _dioClient.get(Endpoints.announcementList);
    return AnnouncementList.fromJson(res);
  }

  //noti's-----------------------------
  Future<NotiModel> getNoti() async {
    final res = await _dioClient.get(Endpoints.noti);
    return NotiModel.fromJson(res);
  }

  //ann detail's----------------------------------
  Future<AnnDetailModel> getAnnDetail(id) async {
    final res = await _dioClient.get(Endpoints.annDetail+"/$id");
    return AnnDetailModel.fromJson(res);
  }

}
