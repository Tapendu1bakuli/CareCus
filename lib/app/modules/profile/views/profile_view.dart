import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;

  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    controller.profileForm = new GlobalKey<FormState>();
    return Obx(()=> Scaffold(
          appBar: hideAppBar
              ? null
              : AppBar(
                  title: Text(
                    "profile".tr,
                    style: context.textTheme.headline6,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                    onPressed: () => Get.back(),
                  ),
                  elevation: 0,
                ),
          body: Form(
            key: controller.profileForm,
            child: ListView(
              primary: true,
              children: [
                Text("profile_details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("change_the_following_details_and_save_them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImageFieldWidget(
                    label: "image".tr,
                    field: 'avatar',
                    tag: controller.profileForm.hashCode.toString(),
                    initialImage: controller.avatar.value,
                    uploadCompleted: (uuid) {
                      controller.avatar.value = new Media(id: uuid);
                    },
                    reset: (uuid) {
                      controller.avatar.value = new Media(thumb: controller.user.value.avatar.thumb);
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.user.value.name = input,
                  validator: (input) => input.length < 3 ? "name_validation".tr : null,
                  initialValue: controller.user.value.name,
                  hintText: "full_name_demo".tr,
                  labelText: "full_name".tr,
                  iconData: Icons.person_outline,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.user.value.email = input,
                  validator: (input) => !GetUtils.isEmail(input) ? "should_be_a_valid_email".tr : null,
                  initialValue: controller.user.value.email,
                  hintText: "email_demo".tr,
                  labelText: "email".tr,
                  iconData: Icons.alternate_email,
                ),
                PhoneFieldWidget(
                  labelText: "phone_number".tr,
                  hintText: "phone_number_demo".tr,
                  initialCountryCode: controller.user.value.getPhoneNumber()?.countryISOCode,
                  initialValue: controller.user.value.getPhoneNumber()?.number,
                  onSaved: (phone) {
                    return controller.user.value.phoneNumber = phone.completeNumber;
                  },
                  suffix: controller.user.value.verifiedPhone
                      ? Text(
                          "verified".tr,
                          style: Get.textTheme.caption.merge(TextStyle(color: Colors.green)),
                        )
                      : Text(
                          "not_verified".tr,
                          style: Get.textTheme.caption.merge(TextStyle(color: Colors.redAccent)),
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, top: TextFieldWidget().topMargin, bottom: TextFieldWidget().bottomMargin),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: TextFieldWidget().buildBorderRadius,
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "address".tr,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      AddressWidget(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
                    ],
                  ),
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.user.value.bio = input,
                  initialValue: controller.user.value.bio,
                  hintText: "your_short_biography_here".tr,
                  labelText: "short_biography".tr,
                  iconData: Icons.article_outlined,
                ),
                Text("change_password".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("fill_your_new_password_and_verify_with_the_otp".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                /*Obx(() {
                  // TODO verify old password
                  return TextFieldWidget(
                    labelText: "Old Password".tr,
                    hintText: "password_hint".tr,
                    onSaved: (input) => controller.oldPassword.value = input,
                    onChanged: (input) => controller.oldPassword.value = input,
                    validator: (input) => input.length > 0 && input.length < 3 ? "name_validation".tr : null,
                    initialValue: controller.oldPassword.value,
                    obscureText: controller.hidePassword.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePassword.value = !controller.hidePassword.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePassword.value ?Icons.visibility_off_outlined :  Icons.visibility_outlined ),                  ),
                    isFirst: true,
                    isLast: false,
                  );
                }),*/
                Obx(() {
                  return TextFieldWidget(
                    labelText: "new_password".tr,
                    hintText: "password_hint".tr,
                    onSaved: (input) => controller.newPassword.value = input,
                    onChanged: (input) => controller.newPassword.value = input,
                    validator: (input) {
                      if (input.length > 0 && input.length < 3) {
                        return "name_validation".tr;
                      }/* else if (input != controller.confirmPassword.value) {
                        return "Passwords do not match".tr;
                      } */else {
                        return null;
                      }
                    },
                    initialValue: controller.newPassword.value,
                    obscureText: controller.hidePasswordNew.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    isFirst: false,
                    isLast: false,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePasswordNew.value = !controller.hidePasswordNew.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePasswordNew.value ?Icons.visibility_off_outlined :  Icons.visibility_outlined ),                  ),
                  );
                }),
                Obx(() {
                  return TextFieldWidget(
                    labelText: "confirm_new_password".tr,
                    hintText: "password_hint".tr,
                    onSaved: (input) => controller.confirmPassword.value = input,
                    onChanged: (input) => controller.confirmPassword.value = input,
                    validator: (input) {
                      if (input.length > 0 && input.length < 3) {
                        return "name_validation".tr;
                      }/* else if (input != controller.newPassword.value) {
                        return "Passwords do not match".tr;
                      } */else {
                        return null;
                      }
                    },
                    initialValue: controller.confirmPassword.value,
                    obscureText: controller.hidePasswordConfirm.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    isFirst: false,
                    isLast: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePasswordConfirm.value = !controller.hidePasswordConfirm.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePasswordConfirm.value ?Icons.visibility_off_outlined :  Icons.visibility_outlined ),                  ),
                  );
                }),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            controller.saveProfileForm();
                          },
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Get.theme.colorScheme.secondary,
                          child: Text("save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                          elevation: 0,
                          highlightElevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                        ),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                        onPressed: () {
                          controller.resetProfileForm();
                        },
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.hintColor.withOpacity(0.1),
                        child: Text("reset".tr, style: Get.textTheme.bodyText2),
                        elevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                      ),
                    ],
                  ).paddingSymmetric(vertical: 10, horizontal: 20),
                ),
              ],
            ),
          )),
    );
  }
}
