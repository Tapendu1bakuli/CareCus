import 'package:get/get.dart';

import '../controllers/book_e_service_controller.dart';
import '../controllers/booking_calender_controller.dart';

class BookEServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookEServiceController>(
      () => BookEServiceController(),
    );
    Get.lazyPut<BookingCalenderController>(
          () => BookingCalenderController(),
    );
  }
}
