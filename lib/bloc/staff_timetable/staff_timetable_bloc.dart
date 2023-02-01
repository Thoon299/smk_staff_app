import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smk/bloc/announcements/announcement_state.dart';
import 'package:smk/bloc/staff_timetable/staff_timetable_event.dart';
import 'package:smk/bloc/staff_timetable/staff_timetable_state.dart';
import 'package:smk/data/repository/staff_timetable_repository.dart';
import 'package:smk/models/staff_timetable/staff_timetable_model.dart';

import '../../data/repository/announcement_repository.dart';
import '../../models/announcements/announcement_model.dart';

class StaffTimetableBloc extends Bloc<StaffTimetableEvent,StaffTimetableState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StaffTimetableRepository staffTimetableRepository;
  StaffTimetableBloc(this.staffTimetableRepository) : super(StaffTimetableEmpty());
  List<PostData> StaffTimetableDataList=[];


  @override
  Stream<StaffTimetableState> mapEventToState(
      StaffTimetableEvent event
      ) async*{
    if(event is FetchStaffTimetable){
      yield StaffTimetableLoading();
      try{
        StaffTimetableList sList = await staffTimetableRepository.getStaffTimetalbeList( event.day);
        yield StaffTimetableLoaded(staffTimetableList: sList);
      }
      catch (e){
        yield StaffTimetableError(errorMessage: e.toString());
      }
    }
  }
}