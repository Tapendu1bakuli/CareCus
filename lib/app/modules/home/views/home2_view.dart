/*
 * File name: home2_view.dart
 * Last modified: 2022.02.17 at 09:53:26
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../book_e_service/controllers/book_e_service_controller.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: false);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Text(
                  Get.find<SettingsService>().setting.value.appName,
                  style: Get.textTheme.headline6,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider.elementAt(controller.currentSlide.value).textPosition),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value == controller.slider.indexOf(slide) ? slide.indicatorColor : slide.indicatorColor.withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    Obx(()=> controller.salons.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: CircularLoadingWidget(
                        height: 100,
                        onCompleteText:
                        "no_service_in_this_location"
                            .tr,
                      ),
                    )
                        : Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(child: Text("recommended_for_you".tr, style: Get.textTheme.headline5)),
                                  MaterialButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.MAPS);
                                    },
                                    shape: StadiumBorder(),
                                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                    child: Text("view_all".tr, style: Get.textTheme.subtitle1),
                                    elevation: 0,
                                  ),
                                ],
                              ),
                            ),
                            RecommendedCarouselWidget(),
                          ],
                        ),),
                    Container(
                      color: Get.theme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(child: Text("categories".tr, style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("view_all".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    CategoriesCarouselWidget(),
                    FeaturedCategoriesWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

}
