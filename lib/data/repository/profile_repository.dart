
import 'dart:io';

import '../../models/profile_model.dart';
import '../network/api/profile/profile_api.dart';

class ProfileRepository {
  //api object
  final ProfileApi profileApi;

  ProfileRepository(this.profileApi);

  Future<ProfileModel> getProfile() async {
    return profileApi.getProfile();
  }


}
