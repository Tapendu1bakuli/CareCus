/*
 * File name: availability_hour_model.dart
 * Last modified: 2022.03.14 at 19:14:30
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:core';

import 'availability_hour_model.dart';
import 'parents/model.dart';

class AvailabilityCalender extends Model {
  bool isOpened;
  AvailabilityHour availabilityHour;
  String date;

  AvailabilityCalender(this.isOpened, this.availabilityHour, this.date,);

  AvailabilityCalender.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    isOpened = boolFromJson(json, 'is_opened');
    date = stringFromJson(json, 'date');
    availabilityHour = AvailabilityHour.fromJson(json["availability_hour"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_opened'] = this.isOpened;
    data['availability_hour'] = this.availabilityHour.toJson();
    data['date'] = this.date;
    return data;
  }
}
