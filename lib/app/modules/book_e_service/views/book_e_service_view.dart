/*
 * File name: book_e_service_view.dart
 * Last modified: 2022.03.11 at 23:35:29
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/book_e_service_controller.dart';
import '../widgets/booking_calender_widget.dart';

class BookEServiceView extends GetView<BookEServiceController> {
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
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.onInit();
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            children: [
              Container(
                decoration: Ui.getBoxDecoration(),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'choose_employee'.tr,
                      style: Get.textTheme.bodyText1,
                    ),
                    SizedBox(height: 10),
                    Container(
                        height: 50.0,
                        child: Obx(
                          () => controller.booking.value.salon.employees.isEmpty
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                      "no_employee_for_this_e_service"
                                          .tr))
                              : ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                    controller
                                        .booking.value.salon.employees.length,
                                    (index) {
                                      var _employee = controller
                                          .booking.value.salon.employees
                                          .elementAt(index);
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        width: 148,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (Get.isRegistered(
                                                tag: 'hours')) {
                                              Get.find<TabBarController>(
                                                      tag: 'hours')
                                                  .selectedId
                                                  .value = "";
                                            }
                                            controller
                                                .selectEmployee(_employee);
                                          },
                                          child: Obx(() {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        child:
                                                            CachedNetworkImage(
                                                          height: 42,
                                                          width: 42,
                                                          fit: BoxFit.cover,
                                                          imageUrl: _employee
                                                              .avatar.thumb,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            'assets/img/loading.gif',
                                                            fit: BoxFit.cover,
                                                            height: 42,
                                                            width: 42,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons
                                                                  .error_outline),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 42,
                                                        width: 42,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .secondary
                                                              .withOpacity(controller
                                                                      .isCheckedEmployee(
                                                                          _employee)
                                                                  ? 0.8
                                                                  : 0),
                                                        ),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 28,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(controller
                                                                      .isCheckedEmployee(
                                                                          _employee)
                                                                  ? 1
                                                                  : 0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(_employee.name,
                                                            style: controller
                                                                .getTitleTheme(
                                                                    _employee))
                                                        .paddingOnly(bottom: 5),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        )),
                  ],
                ),
              ),
              Container(
                decoration: Ui.getBoxDecoration(),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingCalenderWidget(),
                  ],
                ),
              ),
              Obx(() {
                if (!controller.booking.value.canBookingAtSalon)
                  return SizedBox();
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: Ui.getBoxDecoration(
                      color: controller.getColor(controller.atSalon.value)),
                  child: Theme(
                    data: ThemeData(
                      toggleableActiveColor: Get.theme.primaryColor,
                    ),
                    child: RadioListTile(
                      value: true,
                      groupValue: controller.atSalon.value,
                      onChanged: (value) {
                        controller.booking.update((val) {
                          val.address = null;
                          Get.find<TabBarController>(tag: 'addresses')
                              .selectedId = RxString("");
                        });
                        controller.toggleAtSalon(value);
                      },
                      title: Text("at_salon".tr,
                              style: controller
                                  .getTextTheme(controller.atSalon.value))
                          .paddingSymmetric(vertical: 20),
                    ),
                  ),
                );
              }),
              Obx(() {
                if (!controller.booking.value.canBookingAtCustomerAddress)
                  return SizedBox();
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: Ui.getBoxDecoration(
                      color: controller.getColor(!controller.atSalon.value)),
                  child: Theme(
                    data: ThemeData(
                      toggleableActiveColor: Get.theme.primaryColor,
                    ),
                    child: RadioListTile(
                      value: false,
                      groupValue: controller.atSalon.value,
                      onChanged: (value) {
                        controller.toggleAtSalon(value);
                      },
                      title: Text("at_your_address".tr,
                              style: controller
                                  .getTextTheme(!controller.atSalon.value))
                          .paddingSymmetric(vertical: 20),
                    ),
                  ),
                );
              }),
              Obx(() {
                return AnimatedOpacity(
                  opacity: controller.atSalon.value ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    height: controller.atSalon.value ? 0 : 230,
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: controller.atSalon.value ? 0 : 10),
                    padding: EdgeInsets.symmetric(
                        vertical: controller.atSalon.value ? 0 : 20),
                    decoration: Ui.getBoxDecoration(),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Expanded(
                                child: Text("your_addresses".tr,
                                    style: Get.textTheme.bodyText1)),
                            SizedBox(width: 4),
                            MaterialButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              onPressed: () {
                                Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(0.1),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                children: [
                                  Text("new".tr,
                                      style: Get.textTheme.subtitle1),
                                  Icon(
                                    Icons.my_location,
                                    color: Get.theme.colorScheme.secondary,
                                    size: 20,
                                  ),
                                ],
                              ),
                              elevation: 0,
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          if (controller.addresses.isEmpty) {
                            return TabBarLoadingWidget();
                          } else {
                            return TabBarWidget(
                              initialSelectedId: "",
                              tag: 'addresses',
                              tabs: List.generate(controller.addresses.length,
                                  (index) {
                                final _address =
                                    controller.addresses.elementAt(index);
                                return ChipWidget(
                                  tag: 'addresses',
                                  text: _address.getDescription,
                                  id: index,
                                  onSelected: (id) {
                                    controller.booking.update((val) {
                                      val.address = _address;
                                    });
                                    Get.find<SettingsService>().address.value =
                                        _address;
                                  },
                                );
                              }),
                            );
                          }
                        }),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.place_outlined,
                                color: Get.theme.focusColor),
                            SizedBox(width: 15),
                            Expanded(
                              child: Obx(() {
                                return Text(
                                    controller.booking.value.address?.address ??
                                        "select_an_address".tr,
                                    style: Get.textTheme.bodyText2);
                              }),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
                onPressed: (controller.booking.value.bookingAt != null &&
                        (controller.booking.value.address != null ||
                            controller.booking.value.canBookingAtSalon))
                    ? () async {
                        await controller.getTimes(
                            date: controller.booking.value.bookingAt);
                        await Get.toNamed(Routes.BOOK_E_SERVICE_SLOT);
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
