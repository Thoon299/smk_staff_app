import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/announcements/announcement_state.dart';
import 'package:smk/models/announcements/AnnDetailModel.dart';

import '../../data/repository/announcement_repository.dart';
import '../../models/announcements/announcement_model.dart';
import '../../models/announcements/noti_model.dart';
import 'announcement_event.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent,AnnouncementState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  AnnouncementRepository announcementRepository;
  AnnouncementBloc(this.announcementRepository) : super(AnnouncementEmpty());
  List<AData> AnnouncementDataList=[];


  @override
  Stream<AnnouncementState> mapEventToState(
      AnnouncementEvent event
      ) async*{
    if(event is FetchAnnouncement){
      yield AnnouncementLoading();
      try{
        Announcement aList = await announcementRepository.getAnnouncement();
        yield AnnouncementLoaded(aList: aList);
      }
      catch (e){
        yield AnnouncementError(errorMessage: e.toString());
      }
    }

    //noti's--------------------------------------------
    else if(event is FetchNoti){
      yield NotiLoading();
      try{
        NotiModel notiModel = await announcementRepository.getNoti();
        yield NotiLoaded(notiModel: notiModel);
      }
      catch (e){
        yield NotiError(errorMessage: e.toString());
      }
    }


    //anno detail's--------------------------------------------
    else if(event is FetchAnnDetail){
      yield AnnDetailLoading();
      try{
        AnnDetailModel annDetailModel = await announcementRepository.getAnnDetail(event.id);
        yield AnnDetailLoaded(annDetailModel: annDetailModel);
      }
      catch (e){
        yield AnnDetailError(errorMessage: e.toString());
      }
    }
  }
}