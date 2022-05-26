part of 'chanel_bloc.dart';

abstract class ChanelState {}

class AppStarted extends ChanelState {}

class ChanelFail extends ChanelState {
  final String error;
  ChanelFail({required this.error});
}

class ChanelSuccess extends ChanelState {}

class ChanelLoading extends ChanelState {}
