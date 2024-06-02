import 'dart:collection';

import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common/ui.dart';
import 'book_e_service_controller.dart';
import 'package:intl/intl.dart';
class BookingCalenderController extends GetxController {

  DateTime kToday;
  DateTime kFirstDay;
  DateTime kLastDay;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;

  RxSet<DateTime> selectedDays = <DateTime>{}.obs;
  RxSet<String> availableDays = <String>{}.obs;
  @override
  void onInit() {
    kToday = DateTime.now();
    kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 12, DateTime(kToday.year, kToday.month + 12, 0).day);
    selectedDays.value = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    super.onInit();
  }
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      focusedDay = focusedDay;
      // Update values in a Set
      selectedDays.clear();
      if (availableDays.contains(DateFormat('yyyy-MM-dd').format(selectedDay))) {
        selectedDays.add(selectedDay);
        Get.find<BookEServiceController>().booking.update((val) {
          val.bookingAt = selectedDay;
        });
      } else {
        selectedDays.clear();
        Get.find<BookEServiceController>().booking.update((val) {
          val.bookingAt = null;
        });
        Get.showSnackbar(Ui.ErrorSnackBar(message: "booking_not_available_for_this_day".tr));
      }
  }
  void onPageChanged(DateTime focusedDay) {
    kToday = focusedDay;
    Get.find<BookEServiceController>().getAvailability(month: focusedDay.month,year: focusedDay.year);
  }
  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat.value = format;
    }
  }
}
