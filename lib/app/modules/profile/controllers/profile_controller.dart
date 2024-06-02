import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';
import '../../root/controllers/root_controller.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final hidePasswordNew = true.obs;
  final hidePasswordConfirm = true.obs;

  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;
  final loading = false.obs;

  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    Get.lazyPut(() => AuthController());
    getAssociateAddress();
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    super.onInit();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "list_of_faqs_refreshed_successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      try {
        profileForm.currentState.save();
        user.value.deviceToken = null;
        if (newPassword.value == confirmPassword.value) {
          user.value.password = newPassword.value;
        } else {
          throw Exception("mismatch_password".tr);
        }
        user.value.avatar.id = avatar.value.id;
        await _userRepository.sendCodeToPhone();
        Get.bottomSheet(
          PhoneVerificationBottomSheetWidget(),
          isScrollControlled: false,
        );
      } catch (e) {
        Get.find<AuthService>().user.value =
            Get.find<AuthService>().oldUser.value;
        resetProfileForm();
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "errors_in_field".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      getAssociateAddress();
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      loading.value = false;
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "profile_saved_successfully".tr));
    } catch (e) {
      Get.find<AuthService>().user.value =
          Get.find<AuthService>().oldUser.value;
      resetProfileForm();
      loading.value = false;
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAssociateAddress() async {
    if (user.value.address?.latitude == null) {
      if (Get.find<SettingsService>()
          .address
          .value
          .latitude
          .toString()
          .isEmpty) {
        await Get.find<RootController>().getCurrentPosition();
      } else {
        Get.find<AuthService>().user.value.address =
            Get.find<SettingsService>().address.value;
      }
    }
  }
}
