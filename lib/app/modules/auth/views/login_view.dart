import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "login".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: Navigator.of(context).canPop()
              ? new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.primaryColor),
                  onPressed: () =>
                      {Get.find<RootController>().changePageOutRoot(0)},
                )
              : Offstage(),
        ),
        body: Form(
          key: controller.loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.appName,
                            style: Get.textTheme.headline6.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "ultimate_destination"
                                .tr,
                            style: Get.textTheme.caption.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 80,
                    padding: EdgeInsets.symmetric(vertical: 25),
                    decoration: new BoxDecoration(
                      color: Get.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border:
                          Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue)
                  return CircularLoadingWidget(height: 300);
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "email_address".tr,
                        hintText: "email_demo".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) =>
                            controller.currentUser.value.email = input,
                        validator: (input) => !GetUtils.isEmail(input)
                            ? "should_be_a_valid_email".tr
                            : null,
                        iconData: Icons.alternate_email,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "password".tr,
                          hintText: "password_hint".tr,
                          initialValue: controller.currentUser?.value?.password,
                          onSaved: (input) =>
                              controller.currentUser.value.password = input,
                          validator: (input) => input.length < 8
                              ? "password_Validation_error".tr
                              : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGOT_PASSWORD);
                            },
                            child: Text("forgot_password_qsn".tr),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      BlockButtonWidget(
                        onPressed: () {
                          controller.login();
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "login".tr,
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text("no_account_message".tr),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 20),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
