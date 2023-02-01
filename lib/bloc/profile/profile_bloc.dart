import 'package:bloc/bloc.dart';
import 'package:smk/bloc/profile/profile_event.dart';
import 'package:smk/bloc/profile/profile_state.dart';

import '../../data/repository/profile_repository.dart';
import '../../models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  final ProfileRepository profileRepository;
  ProfileBloc(this.profileRepository) : super(ProfileEmpty());

  @override
  Stream<ProfileState> mapEventToState(
      ProfileEvent event
      ) async*{
    if(event is FetchProfile){
      yield ProfileLoading();
      try{
        ProfileModel profileModel = await profileRepository.getProfile();
        yield ProfileLoaded(profileModel: profileModel);
      }
      on Exception{
        yield ProfileError(errorMessage: 'Fail to get profile information.');
      }
      catch(e){
        yield ProfileError(errorMessage: e.toString());
      }
    }
    // else if (event is ProfileStart){
    //   yield ProfileEmpty();
    // }
  }
}