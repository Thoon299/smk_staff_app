import 'package:equatable/equatable.dart';

abstract class BadgeEvent extends Equatable{
  const BadgeEvent();

  @override
  List<Object> get props => [];
}

class FetchBadge extends BadgeEvent{
  String type;
  FetchBadge({ required this.type});


}


class UpdateBadge extends BadgeEvent{
  String type;
  UpdateBadge({required this.type});
}