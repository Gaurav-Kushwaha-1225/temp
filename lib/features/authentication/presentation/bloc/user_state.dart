part of 'user_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class OAuthDoing extends AuthenticationState {}

class OAuthDone extends AuthenticationState {
  final String name;
  final String email;
  final String? photoUrl;

  const OAuthDone({required this.name, required this.email, this.photoUrl});

  @override
  List<Object> get props => [name, email, photoUrl ?? ''];
}

class OAuthError extends AuthenticationState {
  final String message;

  const OAuthError({required this.message});

  @override
  List<Object> get props => [message];
}