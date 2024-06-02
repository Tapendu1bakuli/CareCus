import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/booking_controller.dart';

class BookingAtSalonActionsWidget extends GetView<BookingController> {
  const BookingAtSalonActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _booking = controller.booking;
    return Obx(() {
      if (_booking.value.status == null) {
        return SizedBox(height: 0);
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (_booking.value.status.order == Get.find<GlobalService>().global.value.done && _booking.value.payment == null)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "go_to_checkout".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 22)
                    ],
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () {
                    Get.toNamed(Routes.CHECKOUT, arguments: _booking.value);
                  }),
            ),
          /*if (_booking.value.status.order == Get.find<GlobalService>().global.value.onTheWay)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Ready".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.person_outlined, color: Get.theme.primaryColor, size: 24)
                    ],
                  ),
                  color: Get.theme.hintColor,
                  onPressed: () {
                    controller.readyBookingService();
                  }),
            ),*/
          if (_booking.value.status.order == Get.find<GlobalService>().global.value.received)
            Expanded(
              child: Text(
                "waiting_for_confirmation_from_business".tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1,
              ),
            ),
          /*if (_booking.value.status.order == Get.find<GlobalService>().global.value.received)
            Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Reschedule".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      controller.onRescheduleBookingService();
                    })),*/
          if (_booking.value.status.order == Get.find<GlobalService>().global.value.accepted)
            Expanded(
              child: Text(
                "thanks_for_trusting_us".tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1,
              ),
            ),
          /*if (_booking.value.status.order == Get.find<GlobalService>().global.value.accepted)
            Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Reschedule".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      controller.onRescheduleBookingService();
                    })),*/
          if (_booking.value.status.order >= Get.find<GlobalService>().global.value.done && _booking.value.payment != null)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "leave_a_review".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      //Icon(Icons.star_outlined, color: Get.theme.primaryColor, size: 22)
                    ],
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () {
                    Get.toNamed(Routes.RATING, arguments: _booking.value);
                  }),
            ),
          SizedBox(width: 10),
          if (!_booking.value.cancel && _booking.value.status.order < Get.find<GlobalService>().global.value.accepted)
            MaterialButton(
              onPressed: () {
                controller.cancelBookingService();
              },
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.hintColor.withOpacity(0.1),
              child: Text("cancel".tr, style: Get.textTheme.bodyText2),
              elevation: 0,
            ),
        ]).paddingSymmetric(vertical: 10, horizontal: 20),
      );
    });
  }
}
