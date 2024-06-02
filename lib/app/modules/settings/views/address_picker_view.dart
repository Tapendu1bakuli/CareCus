import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../models/address_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../book_e_service/controllers/book_e_service_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';

class AddressPickerView extends StatelessWidget {
  AddressPickerView();
  Rx<bool> loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> PlacePicker(
        apiKey: Get.find<SettingsService>().setting.value.googleMapsKey,
        initialPosition: Get.find<SettingsService>().address.value.getLatLng(),
        useCurrentLocation: true,
        selectInitialPosition: true,
        usePlaceDetailSearch: true,
        forceSearchOnZoomChanged: true,
        selectedPlaceWidgetBuilder:
            (_, selectedPlace, state, isSearchBarFocused) {
          if (isSearchBarFocused) {
            return SizedBox();
          }
          Address _address =
              Address(address: selectedPlace?.formattedAddress ?? '');
          return FloatingCard(
            height: 300,
            elevation: 0,
            bottomPosition: 0.0,
            leftPosition: 0.0,
            rightPosition: 0.0,
            color: Colors.transparent,
            child: state == SearchingState.Searching || loading.value
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "description".tr,
                        hintText: "my_home".tr,
                        initialValue: _address.description,
                        onChanged: (input) => _address.description = input,
                        iconData: Icons.description_outlined,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "full_address".tr,
                        hintText: "address_demo".tr,
                        initialValue: _address.address,
                        onChanged: (input) => _address.address = input,
                        iconData: Icons.place_outlined,
                        isFirst: false,
                        isLast: true,
                      ),
                      BlockButtonWidget(
                        onPressed: () async {
                          loading.value = true;
                          Get.find<SettingsService>().address.update((val) {
                            val.description = _address.description;
                            val.address = _address.address;
                            val.latitude = selectedPlace.geometry.location.lat;
                            val.longitude = selectedPlace.geometry.location.lng;
                            val.userId = Get.find<AuthService>().user.value.id;
                          });
                          Get.find<AuthService>().user.value.address = Get.find<SettingsService>().address.value;
                          if (Get.isRegistered<BookEServiceController>()) {
                            await Get.find<BookEServiceController>()
                                .getAddresses();
                          }
                          if (Get.isRegistered<RootController>()) {
                            await Get.find<RootController>().refreshPage(0);
                          }
                          loading.value = false;
                          Get.back();
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "pick_here".tr,
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(horizontal: 20),
                      SizedBox(height: 10),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
