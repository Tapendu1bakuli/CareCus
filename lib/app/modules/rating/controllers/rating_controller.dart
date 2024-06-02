/*
 * File name: rating_controller.dart
 * Last modified: 2022.02.10 at 17:59:22
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../root/controllers/root_controller.dart';

class RatingController extends GetxController {
  final review = new Review(rate: 0).obs;
  BookingRepository _bookingRepository;
  Rx<bool> dialogPop = false.obs;
  RatingController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    try{
      review.value.booking = Get.arguments as Booking;
    }catch(error){

    }
    super.onInit();
  }

  Future addReview() async {
    try {
      if (review.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "rate_this_salon_services".tr));
        return;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "tell_us_somethings_about_this_salon_services".tr));
        return;
      }
      // print(review.value.toJson());
      await _bookingRepository.addReview(review.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "your_review_has_been_added".tr));
      if(!dialogPop.value){
        Timer(Duration(seconds: 2), () {
          Get.find<RootController>().changePage(0);
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
