import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/settings_service.dart';

class ThemeModeController extends GetxController {
  final selectedThemeMode = ThemeMode.light.obs;
  GetStorage _box;

  ThemeModeController() {
    _box = new GetStorage();
  }

  @override
  void onInit() {
    initThemeMode();
    super.onInit();
  }

  void initThemeMode() {
    String _themeMode = _box.read<String>('theme_mode');
    switch (_themeMode) {
      case 'ThemeMode.light':
        selectedThemeMode.value = ThemeMode.light;
        break;
      case 'ThemeMode.dark':
        selectedThemeMode.value = ThemeMode.dark;
        break;
      case 'ThemeMode.system':
        selectedThemeMode.value = ThemeMode.system;
        break;
      default:
        selectedThemeMode.value = ThemeMode.system;
    }
  }

  void changeThemeMode(ThemeMode themeMode) {
    print("Theme : $themeMode");
    Get.changeThemeMode(themeMode);
    selectedThemeMode.value = themeMode;
    if (themeMode == ThemeMode.dark) {
      Get.rootController.setTheme(Get.find<SettingsService>().getDarkTheme());
    } else {
      Get.rootController.setTheme(Get.find<SettingsService>().getLightTheme());
    }
    _box.write('theme_mode', themeMode.toString());
    Get.rootController.refresh();
  }
}
