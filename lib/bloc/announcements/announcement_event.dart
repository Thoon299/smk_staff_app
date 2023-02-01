import 'package:equatable/equatable.dart';

abstract class AnnouncementEvent extends Equatable{
  const AnnouncementEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnouncement extends AnnouncementEvent{
  FetchAnnouncement();
}

//noti's-----------------------------------------

class FetchNoti extends AnnouncementEvent{
  FetchNoti();
}

//ann detail's-----------------------------------------

class FetchAnnDetail extends AnnouncementEvent{
  String id;
  FetchAnnDetail({required this.id});
}