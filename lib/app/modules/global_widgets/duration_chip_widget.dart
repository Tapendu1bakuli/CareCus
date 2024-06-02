/*
 * File name: duration_chip_widget.dart
 * Last modified: 2022.02.10 at 01:31:47
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DurationChipWidget extends StatelessWidget {
  const DurationChipWidget({
    Key key,
    @required String durationHours,
    @required String durationMin,
  })  : _durationHours = durationHours,_durationMin = durationMin,
        super(key: key);

  final String _durationHours;
  final String _durationMin;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 28,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Get.locale.toString().startsWith('ar')
              ? Row(
            children: [
              Text(
                "duration_space_colon".tr,
                maxLines: 1,
                textDirection: TextDirection.ltr,
                style: Get.textTheme.bodyLarge,
              ),
              SizedBox(width: 5),
              Text(
                _durationMin,
                maxLines: 1,
                textDirection: TextDirection.ltr,
                style: Get.textTheme.bodyText1,
              ),
              Text(
                ":",
                textDirection: TextDirection.ltr,
                maxLines: 1,
                style: Get.textTheme.bodyText1,
              ),
              Text(
                _durationHours,
                maxLines: 1,
                textDirection: TextDirection.ltr,
                style: Get.textTheme.bodyText1,
              ),
            ],
          )
              : Row(
            children: [
              Text(
                "duration_space_colon".tr,
                maxLines: 1,
                style: Get.textTheme.bodyLarge,
              ),
              SizedBox(width: 5),
              Text(
                _durationHours,
                maxLines: 1,
                style: Get.textTheme.bodyText1,
              ),
              Text(
                ":",
                maxLines: 1,
                style: Get.textTheme.bodyText1,
              ),
              Text(
                _durationMin,
                maxLines: 1,
                style: Get.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
