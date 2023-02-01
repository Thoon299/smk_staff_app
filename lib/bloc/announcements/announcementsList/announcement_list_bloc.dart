import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/announcements/announcement_state.dart';

import '../../../data/repository/announcement_repository.dart';
import '../../../models/announcements/announcement_list_model.dart';
import 'announcement_list_event.dart';
import 'announcement_lsit_state.dart';


class AnnouncementListBloc extends Bloc<AnnouncementListEvent,AnnouncementListState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  AnnouncementRepository announcementRepository;
  AnnouncementListBloc(this.announcementRepository) : super(AnnouncementListEmpty());
  List<PostData> AnnouncementDataList=[];


  @override
  Stream<AnnouncementListState> mapEventToState(
      AnnouncementListEvent event
      ) async*{
    if(event is FetchAnnouncementList){
      yield AnnouncementListLoading();
      try{
        AnnouncementList postData = await announcementRepository.getAnnouncementList();
        yield AnnouncementListLoaded(data: postData);
      }
      catch (e){
        yield AnnouncementListError(errorMessage: e.toString());
      }
    }
  }
}