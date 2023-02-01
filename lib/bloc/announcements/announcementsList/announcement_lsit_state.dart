import 'package:equatable/equatable.dart';

import '../../../models/announcements/announcement_list_model.dart';

abstract class AnnouncementListState extends Equatable{
  @override
  List<Object> get props => [];
}

class AnnouncementListEmpty extends AnnouncementListState{}

class AnnouncementListLoading extends AnnouncementListState{}

class AnnouncementListLoaded extends AnnouncementListState{
  final AnnouncementList data;
  AnnouncementListLoaded({required this.data});
}

class AnnouncementListError extends AnnouncementListState{
  final String errorMessage;
  AnnouncementListError({required this.errorMessage});
}