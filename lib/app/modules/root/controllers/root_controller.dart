/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../account/views/account_view.dart';
import '../../book_e_service/controllers/book_e_service_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;
  Position currentPosition;
  final Smartlook smartLook = Smartlook.instance;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }
  Future<void> initSmartLook() async {
    //await smartLook.log.enableLogging();
    await smartLook.preferences.setProjectKey('b663eafce2038030d3ad1ab9b368e759c7c0e167');
    await smartLook.start();
    smartLook.registerIntegrationListener(CustomIntegrationListener());
    await smartLook.preferences.setWebViewEnabled(true);
  }

  @override
  void onInit() async {
    super.onInit();
    initSmartLook();
    await getCustomPages();
    if (Get.find<SettingsService>().address.value?.isUnknown() ?? true) {
      getCurrentPosition();
    }
  }
  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      getAddressFromLatLng(currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text("location_services_are_disabled".tr)));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(Get.context).showSnackBar(
            SnackBar(content: Text("location_permissions_are_denied".tr)));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context).showSnackBar( SnackBar(
          content: Text("location permissions_are_permanently_denied".tr)));
      return false;
    }
    return true;
  }
  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      Get.find<SettingsService>().address.update((val) {
        val.description = place.subAdministrativeArea;
        val.address = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        val.latitude = position.latitude;
        val.longitude = position.longitude;
        val.userId = Get.find<AuthService>().user.value.id;
        Get.find<AuthService>().user.value.address = Get.find<SettingsService>().address.value;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    if (Get.isRegistered<BookEServiceController>()) {
      await Get.find<BookEServiceController>()
          .getAddresses();
    }
    if (Get.isRegistered<RootController>()) {
      await Get.find<RootController>().refreshPage(0);
    }
  }

  List<Widget> pages = [
    Home2View(),
    BookingsView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          await Get.find<BookingsController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }

  Future<void> userLogOut()async {
    await Get.find<AuthService>().removeCurrentUser();
    initServices();
    await Get.offAllNamed(Routes.ROOT);
  }
  getUpdatedToCurrentLocation()async{
    if (Get.isRegistered<BookEServiceController>()) {
      await Get.find<BookEServiceController>()
          .getAddresses();
    }
    if (Get.isRegistered<RootController>()) {
      await Get.find<RootController>().refreshPage(0);
    }
  }
}
class CustomIntegrationListener implements IntegrationListener {
  @override
  void onSessionReady(String dashboardSessionUrl) {
    debugPrint('---------');
    debugPrint('DashboardUrl:');
    debugPrint(dashboardSessionUrl);
  }

  @override
  void onVisitorReady(String dashboardVisitorUrl) {
    debugPrint('---------');
    debugPrint('DashboardVisitorUrl:');
    debugPrint(dashboardVisitorUrl);
  }
}