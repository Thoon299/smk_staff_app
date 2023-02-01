import 'package:equatable/equatable.dart';

import '../../models/profile_model.dart';

abstract class ProfileState extends Equatable{
  @override
  List<Object> get props => [];
}

class ProfileEmpty extends ProfileState {}
class ProfileLoading extends ProfileState{}

class ProfileLoaded extends ProfileState{
  final ProfileModel profileModel;
  ProfileLoaded({required this.profileModel});
}

class ProfileError extends ProfileState{
  final String errorMessage;
  ProfileError({required this.errorMessage});
}