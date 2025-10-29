import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:vertex/config/routes/routes.dart';
import 'package:vertex/utils/theme.dart';

import 'features/authentication/presentation/bloc/user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const storage = FlutterSecureStorage();
  final GoRouter router = UhlLinkRouter().router;
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
      ),
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(),
      ),
    ],
    child: UhlLink(router: router),
  ));
}

class UhlLink extends StatelessWidget {
  final GoRouter router;

  const UhlLink({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Demo App',
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          theme: UhlLinkTheme.lightTheme,
          darkTheme: UhlLinkTheme.darkTheme,
          routerConfig: router,
        );
      },
    );
  }
}
