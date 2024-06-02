import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<AuthService>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "account".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Get.theme.primaryColor),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          elevation: 0,
          actions: [
            NotificationsButtonWidget(
              iconColor: Get.theme.primaryColor,
              labelColor: Get.theme.hintColor,
            )
          ],
        ),
        body: ListView(
          primary: true,
          children: [
            Obx(() {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 150,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _currentUser.value.name ?? '',
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                          SizedBox(height: 10),
                          Text(_currentUser.value.email ?? '', style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border: Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: _currentUser.value.avatar?.thumb ?? '',
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.person_outline, color: Get.theme.colorScheme.secondary),
                    text: Text("profile".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.PROFILE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.assignment_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("my_bookings".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(1);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.notifications_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("notifications".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.chat_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("messages".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(2);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.settings_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("settings".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.translate_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("languages".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_LANGUAGE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.brightness_6_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Theme_Mode".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_THEME_MODE);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.support_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Help_and_FAQ".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.HELP);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.delete, color: Get.theme.colorScheme.secondary),
                    text: Text("delete_account".tr),
                    onTap: (e) async {
                      _showDeleteDialog(context);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
                    text: Text("logout".tr),
                    onTap: (e) async {
                      Get.back();
                      await Get.find<RootController>().userLogOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "delete_your_account".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Delete_your_account_message".tr, style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                Get.back();
                await deleteUser();
                await Get.find<RootController>().changePage(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser() async {
    try {
      await _userRepository.deleteCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }


}
