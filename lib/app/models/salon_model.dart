/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'package:get/get.dart';

import '../../common/uuid.dart';
import 'address_model.dart';
import 'availability_hour_model.dart';
import 'currency_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'salon_level_model.dart';
import 'tax_model.dart';
import 'user_model.dart';
import 'package:intl/intl.dart';
class Salon extends Model {
  String id;
  String name;
  String description;
  List<Media> images;
  String phoneNumber;
  String salonLevelId;
  String addressId;
  String mobileNumber;
  SalonLevel salonLevel;
  List<AvailabilityHour> availabilityHours;
  double availabilityRange;
  double distance;
  bool closed;
  bool featured;
  Address address;
  Currency currency;
  List<Tax> taxes;

  List<User> employees;
  double rate;
  List<Review> reviews;
  int totalReviews;
  bool verified;

  Salon(
      {this.id,
        this.name,
        this.description,
        this.images,
        this.phoneNumber,
        this.mobileNumber,
        this.salonLevel,
        this.availabilityHours,
        this.availabilityRange,
        this.distance,
        this.closed,
        this.featured,
        this.address,
        this.employees,
        this.rate,
        this.reviews,
        this.totalReviews,
        this.verified,this.salonLevelId,this.addressId});

  Salon.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    salonLevelId = stringFromJson(json, 'salon_level_id');
    addressId = stringFromJson(json, 'address_id');
    description = transStringFromJson(json, 'description', defaultValue: null);
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    salonLevel =
        objectFromJson(json, 'salon_level', (v) => SalonLevel.fromJson(v));
    availabilityHours = listFromJson(
        json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    distance = doubleFromJson(json, 'distance');
    closed = boolFromJson(json, 'closed');
    featured = boolFromJson(json, 'featured');
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'salon_reviews', (v) => Review.fromJson(v));
    totalReviews =
    reviews.isEmpty ? intFromJson(json, 'total_reviews') : reviews.length;
    verified = boolFromJson(json, 'verified');
    currency = objectFromJson(json, 'currency', (v) => Currency.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['closed'] = this.closed;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['distance'] = this.distance;
    data['salon_level_id'] = this.salonLevelId;
    data['address_id'] = this.addressId;
    if (this.images != null) {
      data['image'] = this
          .images
          .where((element) => Uuid.isUuid(element.id))
          .map((v) => v.id)
          .toList();
    }
    return data;
  }
  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    if (phoneNumber != null) data['phone_number'] = this.phoneNumber;
    if (mobileNumber != null) data['mobile_number'] = this.mobileNumber;
    if (this.availabilityRange != null) data['availability_range'] = this.availabilityRange;
    data['salon_level_id'] = this.salonLevelId;
    data['address_id'] = this.addressId;
    if (this.images != null) {
      data['image'] = this
          .images
          .where((element) => Uuid.isUuid(element.id))
          .map((v) => v.id)
          .toList();
    }
    return data;
  }
  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null;
  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours.forEach((element) {
      if (result.containsKey(element.day)) {
        var startAt = '${element.startAt.isNotEmpty ? DateFormat('hh:mm a', Get.locale.toString()).format(DateFormat("HH:mm").parse(element.startAt)) : ""}';
        var endAt = '${element.endAt.isNotEmpty ? DateFormat('hh:mm a', Get.locale.toString()).format(DateFormat("HH:mm").parse(element.endAt)) : ""}';
        result[element.day].add(startAt + ' - ' + endAt);
      } else {
        var startAt = '${element.startAt.isNotEmpty ? DateFormat('hh:mm a', Get.locale.toString()).format(DateFormat("HH:mm").parse(element.startAt)) : ""}';
        var endAt = '${element.endAt.isNotEmpty ? DateFormat('hh:mm a', Get.locale.toString()).format(DateFormat("HH:mm").parse(element.endAt)) : ""}';
        result[element.day] = [startAt + ' - ' + endAt];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is Salon &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              images == other.images &&
              phoneNumber == other.phoneNumber &&
              mobileNumber == other.mobileNumber &&
              salonLevel == other.salonLevel &&
              availabilityRange == other.availabilityRange &&
              distance == other.distance &&
              closed == other.closed &&
              featured == other.featured &&
              address == other.address &&
              rate == other.rate &&
              reviews == other.reviews &&
              totalReviews == other.totalReviews &&
              verified == other.verified;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      salonLevel.hashCode ^
      availabilityRange.hashCode ^
      distance.hashCode ^
      closed.hashCode ^
      featured.hashCode ^
      address.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode;
}
