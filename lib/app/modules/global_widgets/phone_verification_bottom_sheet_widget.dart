/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile/controllers/profile_controller.dart';
import 'block_button_widget.dart';
import 'text_field_widget.dart';

class PhoneVerificationBottomSheetWidget extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // TODO add loading while verification
    return Obx(
      ()=> Container(
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 30,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: (Get.width / 2) - 30),
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.focusColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                //child: SizedBox(height: 1,),
              ),
            ),
            Text(
              "sent_otp_code_message".tr,
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: 20, vertical: 10),
            TextFieldWidget(
              labelText: "otp_code".tr,
              hintText: "otp_demo".tr,
              style: Get.textTheme.headline4.merge(TextStyle(letterSpacing: 8)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (input) => controller.smsSent.value = input,
            ),
            controller.loading.value
                ? Center(child: CircularProgressIndicator())
                : BlockButtonWidget(
              onPressed: () async {
                controller.loading.value = true;
                await controller.verifyPhone();
              },
              color: Get.theme.colorScheme.secondary,
              text: Text(
                "verify".tr,
                style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
              ),
            ).paddingSymmetric(vertical: 30, horizontal: 20),
          ],
        ),
      ),
    );
  }
}
