/*
 * File name: search_view.dart
 * Last modified: 2022.02.10 at 15:02:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../global_widgets/filter_bottom_sheet_widget.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_services_list_widget.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "search".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () {
            controller.textEditingController.clear();
            controller.eServices.clear();
            controller.selectedCategories.clear();
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildSearchBar(),
          SearchServicesListWidget(services: controller.eServices),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Hero(
      tag: Get.arguments ?? '',
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            border: Border.all(
              color: Get.theme.focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
            ),
            Expanded(
              child: Material(
                color: Get.theme.primaryColor,
                child: TextField(
                  controller: controller.textEditingController,
                  style: Get.textTheme.bodyText2,
                  onSubmitted: (value) {
                    controller.searchEServices(keywords: value);
                  },
                  autofocus: true,
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(hintText: "search_for_salon_service".tr),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  FilterBottomSheetWidget(),
                  isScrollControlled: true,
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Get.theme.focusColor.withOpacity(0.1),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                      "filter".tr,
                      style: Get.textTheme.bodyText2, //TextStyle(color: Get.theme.hintColor),
                    ),
                    Icon(
                      Icons.filter_list,
                      color: Get.theme.hintColor,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
