import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const GitHubFinderApp());
}

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final themeMode = ThemeMode.system.obs; // default: follow system

  @override
  void onInit() {
    super.onInit();
    String? savedTheme = _storage.read('themeMode');
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    _storage.write('themeMode', mode.toString());
  }
}

class GitHubFinderApp extends StatelessWidget {
  const GitHubFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      title: 'GitHub Finder',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: Routes.search,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeController.themeMode.value,
    ));
  }
}
