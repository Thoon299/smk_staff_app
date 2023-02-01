import 'package:equatable/equatable.dart';

import '../../models/announcements/noti_update.dart';
import '../../models/badge_model.dart';
import '../../models/std_apply_leave/std_apply_leave_status_model.dart';

abstract class BadgePageState extends Equatable{
  @override
  List<Object> get props => [];
}

class BadgeEmpty extends BadgePageState{}

class BadgeLoading extends BadgePageState{}

class BadgeLoaded extends BadgePageState{
  final BadgeModel badgeModel;
  BadgeLoaded({required this.badgeModel});
}

class BadgeError extends BadgePageState{
  final String errorMessage;
  BadgeError({required this.errorMessage});
}

//update badge
class UpdateBadgeLoading extends BadgePageState{}

class UpdateBadgeLoaded extends BadgePageState{
  final BadgeUpdate notiUpdate;
  UpdateBadgeLoaded({required this.notiUpdate});
}

class UpdateBadgeError extends BadgePageState{
  final String errorMessage;
  UpdateBadgeError({required this.errorMessage});
}