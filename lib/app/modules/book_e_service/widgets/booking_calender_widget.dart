import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../services/translation_service.dart';
import '../controllers/booking_calender_controller.dart';
import 'package:intl/intl.dart';

class BookingCalenderWidget extends GetView<BookingCalenderController> {
  BookingCalenderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TableCalendar(
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            locale:
                "${Get.find<TranslationService>().getLocale().languageCode}_${Get.find<TranslationService>().getLocale().countryCode}",
            firstDay: controller.kFirstDay,
            lastDay: controller.kLastDay,
            focusedDay: controller.kToday,
            calendarFormat: controller.calendarFormat.value,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              // Use values from Set to mark multiple days as selected
              return controller.selectedDays.contains(day);
            },
            onDaySelected: controller.onDaySelected,
            onFormatChanged: controller.onFormatChanged,
            onPageChanged: controller.onPageChanged,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                if (controller.availableDays
                    .contains(DateFormat('yyyy-MM-dd').format(date))) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    color: Colors.transparent,
                    child: Center(
                        child: Text(
                      '${date.day}',
                    )),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    color: Colors.transparent,
                    child: Center(
                        child: Text(
                      '${date.day}',
                      //style: Get.textTheme.caption,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough),
                    )),
                  );
                }
              },
            ),
          ),
        ));
  }
}
