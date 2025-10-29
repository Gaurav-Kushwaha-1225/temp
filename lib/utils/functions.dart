import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

Future<bool> checkUserLoggedIn() async {
  final fb.User? user = fb.FirebaseAuth.instance.currentUser;
  return user != null;
}

Future<Map<String, dynamic>?> getUser() async {
  // Prefer FirebaseAuth current user
  final fb.User? user = fb.FirebaseAuth.instance.currentUser;
  if (user != null) {
    return {
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photo': user.photoURL
    };
  }

  // fallback to secure storage (kept for backward compatibility)
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'user');
  if (token != null) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(token);
      return decoded;
    } catch (_) {
      return null;
    }
  } else {
    return null;
  }
}
