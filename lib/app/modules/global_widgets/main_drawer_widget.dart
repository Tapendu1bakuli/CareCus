/*
 * File name: main_drawer_widget.dart
 * Last modified: 2022.02.11 at 02:22:41
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui.dart';
import '../../repositories/user_repository.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Obx(() {
            if (!Get.find<AuthService>().isAuth) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("welcome".tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("login_account_or_create_new_one_for_free".tr, style: Get.textTheme.bodyText1),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                Text(
                                  "login".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                Text(
                                  "register".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  Get.back();
                  await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  accountEmail: Text(
                    Get.find<AuthService>().user.value.email,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: Get.find<AuthService>().user.value.avatar.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.home_outlined,
            text: "home",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(0);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.place_outlined,
            text: "explore_salons",
            onTap: (e) {
              Get.offAndToNamed(Routes.MAPS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.folder_special_outlined,
            text: "categories",
            onTap: (e) {
              Get.offAndToNamed(Routes.CATEGORIES);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.assignment_outlined,
            text: "bookings",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(1);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.notifications_none_outlined,
            text: "notifications",
            onTap: (e) {
              Get.offAndToNamed(Routes.NOTIFICATIONS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.favorite_outline,
            text: "favorites",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.FAVORITES);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.chat_outlined,
            text: "messages",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(2);
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "application_preferences".tr,
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.account_balance_wallet_outlined,
            text: "wallets",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.WALLETS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.person_outline,
            text: "account",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(3);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "settings",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "languages",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.brightness_6_outlined,
            text: Get.isDarkMode ? "light_theme" : "dark_theme",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "help_and_privacy",
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "help_and_faq",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.HELP);
            },
          ),
          CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<AuthService>().isAuth) {
              return DrawerLinkWidget(
                icon: Icons.delete,
                text: "delete_account",
                onTap: (e) async {
                  _showDeleteDialog(context);
                },
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
          Obx(() {
            if (Get.find<AuthService>().isAuth) {
              return DrawerLinkWidget(
                icon: Icons.logout,
                text: "logout",
                onTap: (e) async {
                  await Get.find<RootController>().userLogOut();
                },
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion)
            ListTile(
              dense: true,
              title: Text(
                "version".tr + " " + Get.find<SettingsService>().setting.value.appVersion,
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
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
                Text("delete_your_account_message".tr, style: Get.textTheme.bodyText1),
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
