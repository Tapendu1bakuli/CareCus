/*
 * File name: book_e_service_view.dart
 * Last modified: 2022.03.11 at 23:35:29
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:table_calendar/table_calendar.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/time_zone_slot_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/book_e_service_controller.dart';
import '../widgets/booking_calender_widget.dart';

class BookEServiceSlotView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "book_the_service".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () {
              Get.find<TabBarController>(tag: 'hours').selectedId.value = "";
              Get.find<TabBarController>(tag: 'hours').selectedIdList.clear();
              Get.back();
            },
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.getTimes(date: controller.booking.value.bookingAt);
            ;
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            children: [
              Container(
                decoration: Ui.getBoxDecoration(),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 5, left: 20, right: 20),
                      child: Text("available_timings".tr,
                          style: Get.textTheme.bodyText2),
                    ),
                    Obx(() {
                      if (controller.timesListWithId.isEmpty) {
                        return TabBarLoadingWidget();
                      } else {
                        return TabBarWidgetGrid(
                          initialSelectedId: "",
                          tag: 'hours',
                          tabs: List.generate(controller.timesListWithId.length,
                              (index) {
                            TimeZoneSlotModel model =
                                controller.timesListWithId[index];
                            if (model.isSelected) {
                              return ChipWidgetMultiSelect(
                                backgroundColor: Get.theme.colorScheme.secondary
                                    .withOpacity(0.2),
                                style: Get.textTheme.bodyText1.merge(TextStyle(
                                    color: Get.theme.colorScheme.secondary)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 15),
                                tag: 'hours',
                                text: model.text,
                                id: model.slotId,
                                onSelected: (id) {
                                  int totalDurationHours = 00;
                                  int totalDurationMin = 00;
                                  controller.booking.value.eServices
                                      .forEach((element) {
                                    totalDurationHours = totalDurationHours +
                                        int.tryParse(element.durationHours);
                                    totalDurationMin = totalDurationMin +
                                        int.tryParse(element.durationMin);
                                  });
                                  controller.booking.update((val) {
                                    val.bookingAt =
                                        DateTime.parse(id).toLocal();
                                  });
                                  DateTime lastDateTime = DateTime.parse(id)
                                      .toLocal()
                                      .add(Duration(
                                          hours: totalDurationHours,
                                          minutes: totalDurationMin));
                                  List<String> idList = <String>[];
                                  int i = model.index;
                                  for (i;
                                      i < controller.timesListWithId.length;
                                      i++) {
                                    if (DateTime.parse(controller
                                                .timesListWithId[i].slotId)
                                            .isBefore(lastDateTime) &&
                                        lastDateTime.isAfter(DateTime.parse(
                                            controller
                                                .timesListWithId[i].slotId))) {
                                      idList.add(
                                          controller.timesListWithId[i].slotId);
                                    }
                                  }
                                  Get.find<TabBarController>(tag: 'hours')
                                      .selectedIdList
                                      .clear();
                                  Get.find<TabBarController>(tag: 'hours')
                                      .selectedIdList
                                      .addAll(idList);
                                },
                              );
                            } else {
                              final strikeThroughController = Get.put(
                                  TabBarController(),
                                  tag: 'hours',
                                  permanent: true);
                              return Stack(
                                children: [
                                  RawChip(
                                    elevation: 0,
                                    label: Text(model.text,
                                        style: strikeThroughController
                                                .isMultiSelected(model.slotId)
                                            ? Get.textTheme.bodyText1.merge(
                                                TextStyle(
                                                    color:
                                                        Get.theme.primaryColor))
                                            : Get.textTheme.overline.copyWith(
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 15),
                                    backgroundColor:
                                        Get.theme.focusColor.withOpacity(0.1),
                                    selectedColor:
                                        Get.theme.colorScheme.secondary,
                                    selected: strikeThroughController
                                        .isMultiSelected(model.slotId),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    showCheckmark: false,
                                    pressElevation: 0,
                                  ),
                                  strikeThroughController
                                                  .selectedIdList.length >
                                              1 &&
                                          strikeThroughController
                                                  .selectedIdList.first ==
                                              (model.slotId)
                                      ? Positioned(
                                          top: 3,
                                          left: 5,
                                          right: 5,
                                          child: Text(
                                            "start".tr,
                                            style: Get.textTheme.labelSmall
                                                .merge(TextStyle(
                                                    color: Get
                                                        .theme.primaryColor)),
                                          ))
                                      : Offstage(),
                                  strikeThroughController
                                                  .selectedIdList.length >
                                              1 &&
                                          strikeThroughController
                                                  .selectedIdList.last ==
                                              (model.slotId)
                                      ? Positioned(
                                          top: 3,
                                          left: 5,
                                          right: 5,
                                          child: Text(
                                            "end".tr,
                                            style: Get.textTheme.labelSmall
                                                .merge(TextStyle(
                                                    color: Get
                                                        .theme.primaryColor)),
                                          ))
                                      : Offstage(),
                                ],
                              );
                            }
                          }),
                        );
                      }
                    }),
                  ],
                ),
              ),
              TextFieldWidget(
                onChanged: (input) =>
                    controller.booking.value.coupon.code = input,
                hintText: "coupon_hint".tr,
                labelText: "coupon_code".tr,
                iconData: Icons.confirmation_number_outlined,
                style: Get.textTheme.bodyText2,
                suffixIcon: MaterialButton(
                  onPressed: () {
                    controller.validateCoupon();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Get.theme.focusColor.withOpacity(0.1),
                  child: Text("apply".tr, style: Get.textTheme.bodyText1),
                  elevation: 0,
                ).marginSymmetric(vertical: 4),
              ),
              TextFieldWidget(
                onChanged: (input) => controller.booking.value.hint = input,
                hintText:
                    "like_us_to_know".tr,
                labelText: "hint".tr,
                iconData: Icons.description_outlined,
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  Widget buildBlockButtonWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "continue".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline6.merge(
                          TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor, size: 20)
                  ],
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: (Get.isRegistered<TabBarController>(tag: 'hours') &&
                        Get.find<TabBarController>(tag: 'hours').initialized &&
                        Get.find<TabBarController>(tag: 'hours')
                                .selectedId
                                .value !=
                            "")
                    ? () async {
                        await Get.toNamed(Routes.BOOKING_SUMMARY);
                      }
                    : null,
              ),
            ),
            SizedBox(width: 20),
            Wrap(
              direction: Axis.vertical,
              spacing: 2,
              children: [
                Text(
                  "subtotal".tr,
                  style: Get.textTheme.caption,
                ),
                Ui.getPrice(
                    controller.booking.value.getSubtotal() -
                        controller.booking.value.getCouponValue(),
                    currency: controller.booking.value?.salon?.currency,
                    style: Get.textTheme.headline6),
              ],
            )
          ],
        );
      }),
    );
  }
}
