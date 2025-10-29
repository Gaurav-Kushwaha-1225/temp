// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/presentation/pages/choose_auth.dart';
import 'package:vertex/features/home/presentation/pages/dashboard.dart';
import 'package:vertex/widgets/test.dart';

class UhlLinkRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          name: UhlLinkRoutesNames.oAuth,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const ChooseAuthPage());
          }),
      //
      GoRoute(
          name: UhlLinkRoutesNames.dashboard,
          path: '/dashboard',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: Dashboard(
                ));
          }),
    ],
    // redirect: (BuildContext context, GoRouterState state) async {
    //   const storage = FlutterSecureStorage();
    //   final token = await storage.read(key: 'user');
    //
    //   if (token == null) {
    //     if (state.matchedLocation != '/chooseAuth') {
    //       return '/chooseAuth';
    //     }
    //   }
    //   else if (state.matchedLocation == '/chooseAuth') {
    //     final user = jsonDecode(token);
    //     return '/home/false/$user';
    //   }
    //
    //   return null; // Allow navigation if conditions are met
    // }
  );
}
