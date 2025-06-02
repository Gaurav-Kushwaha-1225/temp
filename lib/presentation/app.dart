import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../utils/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Note Explorer',
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return Obx(() {
          final themeController = Get.find<ThemeController>();
          return Theme(
            data: themeController.isDarkMode.value
                ? AppThemes.darkTheme
                : AppThemes.lightTheme,
            child: child!,
          );
        });
      },
    );
  }
}
