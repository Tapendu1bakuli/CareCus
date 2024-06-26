/*
 * File name: payment_details_widget.dart
 * Last modified: 2022.02.11 at 23:30:33
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../bookings/widgets/booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: _booking.salon.firstImageUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: <Widget>[
                Text(
                  _booking.salon.name ?? '',
                  style: Get.textTheme.bodyText2,
                  maxLines: 3,
                  // textAlign: TextAlign.end,
                ),
                Divider(height: 8, thickness: 1),
                BookingRowWidget(
                  description: "tax_amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getTaxesValue(),currency: _booking?.salon?.currency, style: Get.textTheme.subtitle2),
                  ),
                ),
                BookingRowWidget(
                  description: "subtotal".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getSubtotal(),currency: _booking?.salon?.currency, style: Get.textTheme.subtitle2),
                  ),
                ),
                if ((_booking.coupon?.discount ?? 0) > 0)
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
                    hasDivider: false,
                  ),
                BookingRowWidget(
                  description: "total_amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getTotal(),currency: _booking?.salon?.currency, style: Get.textTheme.headline6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
