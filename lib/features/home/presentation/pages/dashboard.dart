import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/presentation/bloc/user_bloc.dart';
import 'package:vertex/widgets/screen_width_button.dart';
import 'package:vertex/utils/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  String email = "";
  String? photoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final fb.User? user = fb.FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          name = user.displayName ?? '';
          email = user.email ?? '';
          photoUrl = user.photoURL;
          isLoading = false;
        });
        return;
      }
      // fallback to secure storage
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'user');
      if (token != null) {
        final Map<String, dynamic> data = jsonDecode(token);
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          photoUrl = data['photo'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    context.read<AuthenticationBloc>().signOut();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 23),
        ),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: context.watch<ThemeBloc>().state.isDark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ToggleTheme());
              },
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
              inactiveTrackColor: Theme.of(context).colorScheme.scrim,
              trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        primary: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 48,
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : null,
              child: (photoUrl == null || photoUrl!.isEmpty)
                  ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?')
                  : null,
            ),
            const SizedBox(height: 16),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(email, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 24),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            // screen width logout button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ScreenWidthButton(
                text: "Logout",
                buttonFunc: _signOut,
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
