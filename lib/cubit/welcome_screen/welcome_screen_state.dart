part of 'welcome_screen_cubit.dart';

abstract class WelcomeScreenState extends Equatable {
  const WelcomeScreenState();

  @override
  List<Object> get props => [];
}

class WelcomeScreenInitial extends WelcomeScreenState {}

class WelcomeScreenLoading extends WelcomeScreenState {}

class WelcomeScreenSnapshots extends WelcomeScreenState {
  final List<StorageItem>? snapshots;

  const WelcomeScreenSnapshots(this.snapshots);
}

class WelcomeScreenError extends WelcomeScreenState {}
