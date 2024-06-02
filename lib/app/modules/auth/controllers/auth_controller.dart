import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  UserRepository _userRepository;
  Timer timer;
  Rx<int> secondsRemaining = 0.obs;
  Rx<bool> enableResend = false.obs;
  Rx<bool> userVerified = false.obs;

  AuthController() {
    _userRepository = UserRepository();
  }

  addTimer() {
    secondsRemaining.value = 30;
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true;
      }
    });
  }

  void resendCode() {
    //other code here
    addTimer();
    secondsRemaining.value = 30;
    enableResend.value = false;
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);
        if (currentUser.value.apiToken != null &&
            currentUser.value.apiToken.isNotEmpty) {
          await _userRepository.signInWithEmailAndPassword(
              currentUser.value.email, currentUser.value.apiToken);
          await Get.toNamed(Routes.ROOT, arguments: 0);
        } else {
          currentUser.value.auth = false;
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      if (currentUser.value.phoneNumber.isNotEmpty &&
          currentUser.value.phoneNumber.length > 5) {
        try {
          await _userRepository.sendCodeToPhone();
          loading.value = false;
          addTimer();
          await Get.toNamed(Routes.PHONE_VERIFICATION);
        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        } finally {
          loading.value = false;
        }
      } else {
        loading.value = false;
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "should_be_a_valid_phone".tr));
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email, currentUser.value.apiToken);
      await Get.find<RootController>().changePage(0);
    } catch (e) {
      Get.back();
      Get.find<AuthController>().userVerified.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message: "password_sent_to_email".tr + currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
