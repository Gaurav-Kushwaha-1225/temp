import 'package:blogexplorer/injection_container.dart';
import 'package:blogexplorer/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  Get.put(ThemeController(), permanent: true);
  initInjection();

  runApp(const App());
}
