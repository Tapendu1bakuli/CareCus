import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/availability_Calender_model.dart';
import '../models/setting_model.dart';
import '../providers/laravel_provider.dart';

class SettingRepository {
  LaravelApiClient _laravelApiClient;

  SettingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Setting> get() {
    return _laravelApiClient.getSettings();
  }

  Future<Map<String, String>> getTranslations(String locale) {
    return _laravelApiClient.getTranslations(locale);
  }

  Future<List<String>> getSupportedLocales() {
    return _laravelApiClient.getSupportedLocales();
  }

  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }
  Future<List<AvailabilityCalender>> getAvailabilityMonth(String eProviderId,int month, int year) {
    return _laravelApiClient.getAvailabilityMonth(eProviderId,month,year);
  }
}
