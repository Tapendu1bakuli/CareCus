import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool dialogShown = false;

  Future<ConnectivityService> init() async {
    await initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
    return this;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    checkInternet().then((result) {
      if (result == true) {
        if (dialogShown) {
          dialogShown = false;
          if (Get.context != null) Get.back();
        }
      }
    });
    if (connectionStatus == ConnectivityResult.none) {
      try {
        if (!dialogShown) showDialogView();
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print("InterNet REsult: $result");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  void showDialogView() {
    dialogShown = true;
    Get.defaultDialog(
      title: "connection_status".tr,
      barrierDismissible: false,
      middleText: "no_internet_connection".tr,
      titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }
}
