import 'package:equatable/equatable.dart';

abstract class AnnouncementListEvent extends Equatable{
  const AnnouncementListEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnouncementList extends AnnouncementListEvent{
  FetchAnnouncementList();
}