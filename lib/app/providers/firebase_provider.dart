import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../services/auth_service.dart';

class FirebaseProvider extends GetxService {
  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      fba.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    fba.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    try {
      final fba.AuthCredential credential = fba.PhoneAuthProvider.credential(
          verificationId: Get.find<AuthService>().user.value.verificationId,
          smsCode: smsCode);
      await fba.FirebaseAuth.instance.signInWithCredential(credential);
      Get.find<AuthService>().user.value.verifiedPhone = true;
      Get.find<AuthController>().userVerified.value = true;
    } catch (e) {
      Get.find<AuthController>().userVerified.value = false;
      Get.find<AuthService>().user.value.verifiedPhone = false;
      Get.find<AuthService>().user.value =
          Get.find<AuthService>().oldUser.value;
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().resetProfileForm();
      }
      throw Exception(e.toString());
    }
  }

  Future<void> sendCodeToPhone() async {
    Get.find<AuthService>().user.value.verificationId = '';
    final fba.PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    final fba.PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
    };
    final fba.PhoneVerificationCompleted _verifiedSuccess = (fba.AuthCredential auth) async {};
    final fba.PhoneVerificationFailed _verifyFailed = (fba.FirebaseAuthException e) {
      Get.find<AuthService>().user.value =
          Get.find<AuthService>().oldUser.value;
      bool registeredProfile = Get.isRegistered<ProfileController>();
      if(registeredProfile)
      if (Get.find<ProfileController>() != null) {
        Get.find<ProfileController>().resetProfileForm();
      } else {
        Get.find<AuthController>().userVerified.value = false;
        Get.find<AuthService>().user.value.verifiedPhone = false;
      }
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.message.tr));
      Get.find<AuthService>().user.value =
          Get.find<AuthService>().oldUser.value;
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().resetProfileForm();
      }
      throw Exception(e.message);
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: Get.find<AuthService>().user.value.phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future signOut() async {
    return await _auth.signOut();
  }

  Future<void> deleteCurrentUser() async {
    return await _auth.currentUser?.delete();
  }

}
