import 'package:equatable/equatable.dart';
import 'package:smk/models/announcements/AnnDetailModel.dart';

import '../../models/announcements/announcement_model.dart';
import '../../models/announcements/noti_model.dart';

abstract class AnnouncementState extends Equatable{
  @override
  List<Object> get props => [];
}

class AnnouncementEmpty extends AnnouncementState{}

class AnnouncementLoading extends AnnouncementState{}

class AnnouncementLoaded extends AnnouncementState{
  final Announcement aList;
  AnnouncementLoaded({required this.aList});
}

class AnnouncementError extends AnnouncementState{
  final String errorMessage;
  AnnouncementError({required this.errorMessage});
}


//noti's--------------------------------------
class NotiLoading extends AnnouncementState{}

class NotiLoaded extends AnnouncementState{
  final NotiModel notiModel;
  NotiLoaded({required this.notiModel});
}

class NotiError extends AnnouncementState{
  final String errorMessage;
  NotiError({required this.errorMessage});
}


//ann detail's--------------------------------------
class AnnDetailLoading extends AnnouncementState{}

class AnnDetailLoaded extends AnnouncementState{
  final AnnDetailModel annDetailModel;
  AnnDetailLoaded({required this.annDetailModel});
}

class AnnDetailError extends AnnouncementState{
  final String errorMessage;
  AnnDetailError({required this.errorMessage});
}