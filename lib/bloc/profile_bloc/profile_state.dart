part of 'profile_bloc.dart';

abstract class ProfileState {}

class AppStarted extends ProfileState {}

class ProfileSuccess extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure({required this.error});
}

class ProfileLoading extends ProfileState {}
