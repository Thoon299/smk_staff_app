import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/models/badge_model.dart';

import '../../data/repository/badge_repository.dart';
import '../../models/announcements/noti_update.dart';
import 'badge.event.dart';
import 'badge_page.state.dart';


class BadgeBloc extends Bloc<BadgeEvent,BadgePageState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  BadgeRepository badgeRepository;
  BadgeBloc(this.badgeRepository) : super(BadgeEmpty());

  @override
  Stream<BadgePageState> mapEventToState(
      BadgeEvent event
      ) async*{
    if(event is FetchBadge){
      yield BadgeLoading();
      try{
        BadgeModel badgeModel = await badgeRepository.getBadge( event.type);
        yield BadgeLoaded(badgeModel: badgeModel);
      }
      catch (e){
        yield BadgeError(errorMessage: e.toString());
      }
    }

    //remove badge
    else if(event is UpdateBadge){
      yield UpdateBadgeLoading();
      try{
        BadgeUpdate badgeUpdate =
        await badgeRepository.updateBadge(
            event.type);

      }
      catch (e){
        yield UpdateBadgeError(errorMessage: e.toString());
      }
    }
  }
}