part of 'user_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthenticationEvent {}
