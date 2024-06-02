import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/rating_controller.dart';

class RatingDialog extends GetView<RatingController> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      content: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: Ui.getBoxDecoration(),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl:
                          controller.review.value.booking.salon.firstImageUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 160,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    controller.review.value.booking.salon.name,
                    style: Get.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "click_on_the_stars_to_rate_this_salon_services".tr,
                    style: Get.textTheme.caption,
                  ),
                  SizedBox(height: 6),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            controller.review.update((val) {
                              val.rate = (index + 1).toDouble();
                            });
                          },
                          child: index < controller.review.value.rate
                              ? Icon(Icons.star,
                                  size: 40, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border,
                                  size: 40, color: Color(0xFFFFB24D)),
                        );
                      }),
                    );
                  }),
                  SizedBox(height: 30)
                ],
              ),
            )),
        TextFieldWidget(
          padding: EdgeInsets.zero,
          labelText: "write_your_review".tr,
          hintText: "tell_us_somethings_about_this_salon_services".tr,
          iconData: Icons.description_outlined,
          onChanged: (text) {
            controller.review.update((val) {
              val.review = text;
            });
          },
        ),
        BlockButtonWidget(
            text: Text(
              "submit_review".tr,
              style: Get.textTheme.headline6
                  .merge(TextStyle(color: Get.theme.primaryColor)),
            ),
            color: Get.theme.colorScheme.secondary,
            onPressed: () {
              Get.back();
              controller.dialogPop.value = true;
              controller.addReview();
            }).marginSymmetric(vertical: 20, horizontal: 20),
      ]),
    );
  }
}
