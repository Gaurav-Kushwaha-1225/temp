import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

part 'user_event.dart';
part 'user_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthenticationState> emit) async {
    emit(OAuthDoing());
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(const OAuthError(message: "Sign in aborted by user."));
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final name = user.displayName ?? '';
        final email = user.email ?? '';
        final photo = user.photoURL;
        await _storage.write(
            key: 'user',
            value: jsonEncode({'name': name, 'email': email, 'photo': photo}));
        emit(OAuthDone(name: name, email: email, photoUrl: photo));
      } else {
        emit(const OAuthError(message: "Google sign-in failed."));
      }
    } catch (e) {
      emit(OAuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _storage.delete(key: 'user');
      // emit(AuthenticationInitial());
    } catch (_) {}
  }
}
