/*
 * File name: payment_details_widget.dart
 * Last modified: 2022.02.12 at 01:39:43
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import 'booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    List<Widget> _paymentDetails = [
      Column(
        children: List.generate(_booking.taxes.length, (index) {
          var _tax = _booking.taxes.elementAt(index);
          return BookingRowWidget(
              description: _tax.name,
              child: Align(
                alignment: Alignment.centerRight,
                child: _tax.type == 'percent'
                    ? Text(_tax.value.toString() + '%', style: Get.textTheme.bodyText1)
                    : Ui.getPrice(
                        _tax.value,
                        currency: _booking?.salon?.currency,
                        style: Get.textTheme.bodyText1,
                      ),
              ),
              hasDivider: (_booking.taxes.length - 1) == index);
        }),
      ),
      BookingRowWidget(
        description: "tax_amount".tr,
        child: Align(
          alignment: Alignment.centerRight,
          child: Ui.getPrice(_booking.getTaxesValue(),currency: _booking?.salon?.currency, style: Get.textTheme.subtitle2),
        ),
        hasDivider: false,
      ),
      BookingRowWidget(
          description: "subtotal".tr,
          child: Align(
            alignment: Alignment.centerRight,
            child: Ui.getPrice(_booking.getSubtotal(),currency: _booking?.salon?.currency, style: Get.textTheme.subtitle2),
          ),
          hasDivider: true),
      if ((_booking.getCouponValue() > 0))
        BookingRowWidget(
            description: "coupon".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [
                  Text(' - ', style: Get.textTheme.bodyText1),
                  Ui.getPrice(_booking.getCouponValue(),currency: _booking?.salon?.currency, style: Get.textTheme.bodyText1),
                ],
              ),
            ),
            hasDivider: true),
      BookingRowWidget(
        description: "total_amount".tr,
        child: Align(
          alignment: Alignment.centerRight,
          child: Ui.getPrice(_booking.getTotal(),currency: _booking?.salon?.currency, style: Get.textTheme.headline6),
        ),
      ),
    ];
    _booking.eServices.forEach((_eService) {
      var _options = _booking.options.where((option) => option.eServiceId == _eService.id);
      _paymentDetails.insert(
        0,
        Wrap(
          children: [
            BookingRowWidget(
              description: _eService.name,
              child: Align(
                alignment: Alignment.centerRight,
                child: Ui.getPrice(_eService.getPrice,currency: _eService?.salon?.currency, style: Get.textTheme.subtitle2),
              ),
              hasDivider: true,
            ),
            Column(
              children: List.generate(_options.length, (index) {
                var _option = _options.elementAt(index);
                return BookingRowWidget(
                    description: _option.name,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Ui.getPrice(_option.price,currency: _booking?.salon?.currency, style: Get.textTheme.bodyText1),
                    ),
                    hasDivider: (_options.length - 1) == index);
              }),
            ),
          ],
        ),
      );
    });
    return Column(
      children: _paymentDetails,
    );
  }
}
