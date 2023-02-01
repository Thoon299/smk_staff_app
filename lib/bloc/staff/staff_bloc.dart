import 'package:bloc/bloc.dart';
import 'package:smk/bloc/staff/staff_event.dart';
import 'package:smk/bloc/staff/staff_state.dart';
import '../../data/repository/staff_repository.dart';
import '../../models/staff/staff_model.dart';


class StaffBloc extends Bloc<StaffEvent,StaffState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  StaffRepository staffRepository;
  StaffBloc(this.staffRepository) : super(StaffEmpty());
  List<PostData> staffList=[];


  @override
  Stream<StaffState> mapEventToState(
      StaffEvent event
      ) async*{
    if(event is FetchStaff){
      yield StaffLoading();
      try{
        StaffModel staffModel = await staffRepository.getStaff(event.search);
        yield StaffLoaded(staffModel: staffModel);
      }
      catch (e){
        yield StaffError(errorMessage: e.toString());
      }
    }
  }
}