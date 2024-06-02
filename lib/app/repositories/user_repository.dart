import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> login(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<void> deleteCurrentUser() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _firebaseProvider.deleteCurrentUser().then((value) =>
        _laravelApiClient.deleteUser(Get.find<AuthService>().user.value));
    Get.find<AuthService>().user.value = new User();
    GetStorage().remove('current_user_customer');
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut(User user) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    _laravelApiClient = Get.find<LaravelApiClient>();
    await _firebaseProvider.signOut();
    if(Get.isRegistered<AuthController>()){
      Get.find<AuthController>().loading.value = false;
    }
    return await _laravelApiClient.signOut(user);
  }
}
