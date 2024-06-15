part of 'app_user_cubit.dart';

sealed class AppUserState extends Equatable {
  const AppUserState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class AppUserInitial extends AppUserState {
  String? message;

  AppUserInitial({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

final class AppUserLoggedIn extends AppUserState {
  final UserModel user;

  const AppUserLoggedIn(this.user);

  @override
  List<Object> get props => [user];
}
